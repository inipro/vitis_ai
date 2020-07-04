import os
import argparse
import tensorflow as tf

def main(graph_path):

    directory = os.path.dirname(graph_path)
    old_path = os.path.join(directory, 'temp.pb')
    os.rename(graph_path, old_path)
    with tf.gfile.FastGFile(old_path, 'rb') as f:
        graph_def = tf.GraphDef()
        graph_def.ParseFromString(f.read())
    os.remove(old_path)

    for node in graph_def.node:
        if node.name == 'batch_normalization_5/batchnorm_1/add_1':
            node.op = 'Add'
    with tf.gfile.FastGFile(graph_path, 'wb') as f:
        f.write(graph_def.SerializeToString())

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--graph', type=str,
                        default='./freeze/frozen_graph.pb',
                        help='graph file (.pb) to be fixed.')
    args = parser.parse_args()
    main(args.graph)


