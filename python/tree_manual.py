__author__ = 'nineil'

from nltk.tree import *
from nltk.draw import tree
from pprint import pprint

# functions
def map2tree(d, node):
    if d.get(node) == None:
        return Tree(node, ['*'])
    else:
        childs = d[node]
        vl = []
        for child in childs:
            t = map2tree(d, child)
            vl.append(t)
        return Tree(node, vl)

# main
one_tree = {'animal': ['air', 'land', 'water'],
        'air': ['ibis', 'hawksbill', 'hummingbird', 'cormorant', 'duck', 'goose', 'ostrich', 'owl', 'penguin', 'swan'],
        'land': ['bat', 'bear', 'camel', 'chimp', 'dog', 'elephant', 'elk', 'frog', 'giraffe', 'goat', 'gorilla', 'horse', 'iguana', 'kangaroo', 'llama', 'leopards', 'porcupine', 'raccoon', 'skunk', 'snake', 'snail', 'zebra', 'greyhound', 'toad'],
        'water': ['horseshoe-crab', 'crab', 'conch', 'dolphin', 'goldfish', 'killer-whale', 'mussels', 'octopus', 'starfish']}

root_name = 'animal'

t = map2tree(one_tree, root_name)
print t
pprint(t)
t.draw()

