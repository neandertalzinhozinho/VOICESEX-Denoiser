"""Export persistent-context graphs without changing the research originals."""
from pathlib import Path
import onnx
from onnx import helper

root = Path(__file__).resolve().parents[2]
dest = Path(__file__).resolve().parent / 'models'
dest.mkdir(exist_ok=True)
for key, ident, ctx in [('df_enc','02BACC00',(2,2,108)),('df_dec','02D060E0',(64,5,108)),
                       ('erb_enc','02F48EA0',(1,2,56)),('erb_dec','02F8FF00',None)]:
    model = onnx.load(root / 'models' / f'model_0x{ident}.onnx')
    for node in list(model.graph.node):
        if 'final_frame' in node.name and node.op_type in ('Gather','Slice','Unsqueeze'):
            index = list(model.graph.node).index(node)
            replacement = helper.make_node('Identity', [node.input[0]], list(node.output))
            model.graph.node.remove(node)
            model.graph.node.insert(index, replacement)
    if ctx:
        pad = next(n for n in model.graph.node if n.op_type == 'Pad')
        model.graph.input.append(helper.make_tensor_value_info('conv_history', onnx.TensorProto.FLOAT, [1,*ctx]))
        index = list(model.graph.node).index(pad)
        replacement = helper.make_node('Concat', ['conv_history',pad.input[0]], list(pad.output), axis=2)
        model.graph.node.remove(pad)
        model.graph.node.insert(index,replacement)
    onnx.checker.check_model(model)
    onnx.save(model,dest / f'{key}.onnx')
    print(key)
