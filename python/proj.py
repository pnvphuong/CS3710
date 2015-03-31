__author__ = 'nineil'

import csv
from nltk.corpus import wordnet as wn
from nltk.tree import *
from nltk.draw import tree
from pprint import pprint

# lambda functions
hyp = lambda s: s.hypernyms()
get_one_tree = lambda x: reduce(merge_trees, x)
get_trees_v2 = lambda sa, p: get_trees(sa, words, p)

# Functions
def is_noun2(s):
    print s.lexname(); # lexname(): noun.animal -- name(): skunk.n.04 --offset(): 7782475
    if s.pos() == wn.NOUN:
        return True
    else:
        return False

# Function transform list to tree, It generates bottom-up Tree
def list2map(list_vector, dict):
    # base case
    root = str(list_vector[0].name())
    childs = []
    for i in range(1, len(list_vector)):
        el = list_vector[i][0]
        el = str(el.name())
        childs.append(el)

    if dict.get(root) != None:
        dict[root][0] = dict[root][0] + 1 # update count
    else:
        if len(childs) == 0:
            v= [1] # This is for the root node
        else:
            v = [len(childs)] # everyone starts with count 1
        for i in range(len(childs)):
            v.append(childs[i])
        dict[root] = v

    # print
    # print 'root: ', root
    # print 'childs: ', childs
    # print 'dict: ', dict

    # recursion step
    for i in range(1, len(list_vector)):
        list2map(list_vector[i], dict)

# Function reverse a tree
def reverse_tree(dict, root, dict_out):
    # base case
    childs = dict[root]
    for i in range(1, len(childs)):
        child = childs[i]
        if dict_out.get(child) == None:
            count_child = dict[child][0]
            dict_out[child] = [count_child, root]
        else:
            if not(root in dict_out[child]):
                dict_out[child].append(root)

    # recursive case
    for i in range(1, len(childs)):
        child = childs[i]
        reverse_tree(dict, child, dict_out)

# Merge two trees
def merge_trees(d1, d2):
    ds = dict(d2) # so it works by value and not by reference
    for k in d1.keys():
        if d1.get(k) != None and ds.get(k) != None:
            c = ds[k][0] + d1[k][0] # merge count
            l1 = ds[k][1:]
            l2 = d1[k][1:]
            lr = [c] + list(set(l1+l2))
            ds[k] = lr
            # merge nodes
        elif d1.get(k) != None and ds.get(k) == None:
            ds[k] = d1[k] # add a new node
    return ds

def get_synset(word):
    if word == 'horseshoe-crab':
        word = 'crab'
    if word == 'killer-whale': # mention the way to have a base word?
        word = 'whale';
    s = wn.synsets(word);
    s = filter(lambda x: x.pos() == wn.NOUN, s) # consider only nouns
    return s

def get_trees(synsets_array, words, pos):
    # vt = map(wn.synset.tree, synsets_array, [hyp] *len(synsets_array)) # not work
    vt = [];
    for i in range(len(synsets_array)):
        sel = synsets_array[i]
        root_name = str(sel.name())
        r = sel.tree(hyp)
        ds = dict({})
        d = {}
        list2map(r, d)
        reverse_tree(d, root_name, ds)
        ds[root_name] = [1, words[pos]]
        vt.append(ds)
    return vt

def map2tree(d, name_synset):
    if d.get(name_synset) == None:
        return Tree(name_synset, ['*'])
    else:
        childs = d[name_synset]
        vl = []
        for i in range(1, len(childs)):
            child = childs[i]
            t = map2tree(d, child)
            vl.append(t)
        return Tree(name_synset, vl)

# reading data
data_file = 'leaves.txt';
f = open(data_file)
csv_f = csv.reader(f)

# transform data to a vector
v = []
for row in csv_f:
  v.append(row[0])

words = v[1:]
word_synsets = map(get_synset, words) # extract synsets
word_trees = map(get_trees_v2, word_synsets, range(len(words))) # get maps [top - down]
combined_trees = map(get_one_tree, word_trees) # create one tree per word
one_tree = reduce(merge_trees, combined_trees) # merge in only one tree

# print "words: ", words, len(words)
# print "word_synsets: ", word_synsets, len(word_synsets)
# print "word_trees: ", word_trees

print "one_tree: "
pprint(one_tree)

t = map2tree(one_tree, 'entity.n.01')
print t
t.draw()