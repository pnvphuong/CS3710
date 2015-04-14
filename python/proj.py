__author__ = 'nineil'

import csv
from nltk.corpus import wordnet as wn
from nltk.tree import *
from nltk.draw import tree
from pprint import pprint
import numpy as np
from collections import Counter

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
        return Tree(name_synset + ' [ ' + str(childs[0]) + ' ]', vl)

def get_leaves(h, root_name):
    # base case [leaf]
    if h.has_key(root_name) == False:
        return [root_name]
    else:
        childs = h[root_name]
        childs = childs[1:]
        v = [];
        for child in childs:
            leave = get_leaves(h, child)
            v = v + leave
        return v

def decrease_counts(count_v, count_child):
    count_out = count_v
    for k in count_child.keys():
        count_out[k] = count_v[k] - count_child[k]
    return count_out


def get_common_root(h, root_name, count_v, num_words):
    childs = h[root_name]
    childs = childs[1:]
    count_childs = map(lambda x: h[x][0], childs)
    max_val = max(count_childs)
    max_ix = count_childs.index(max_val)

    # Access subtree with maximum count
    leaves_child = get_leaves(h, childs[max_ix])
    counter_child = Counter(leaves_child)

    if len(counter_child) < num_words:
        return [h, root_name]# new common root
    else:
        # Access child
        max_child = childs[max_ix]
        count_new = count_v
        # Delete other childs
        for i in range(len(childs)):
            if i != max_ix:
                leaves_child = get_leaves(h, childs[i])
                counter_child = Counter(leaves_child)
                count_new = decrease_counts(count_new, counter_child)
                del h[childs[i]]
        del h[root_name]
        return get_common_root(h, max_child, count_new, num_words)

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
num_word_synsets = map(len, word_synsets) # number of word synsets
word_trees = map(get_trees_v2, word_synsets, range(len(words))) # get maps [top - down]
combined_trees = map(get_one_tree, word_trees) # create one tree per word
one_tree = reduce(merge_trees, combined_trees) # merge in only one tree

# print "words: ", words, len(words)
# print "num_word_synsets: ", num_word_synsets, len(num_word_synsets)
# print "average num_word_synsets: ", np.mean(num_word_synsets)
# print "std num_word_synsets: ", np.std(num_word_synsets)
# print "max num_word_synsets: ", np.max(num_word_synsets)
# # print "word_trees: ", word_trees
#
# print "one_tree: "
# pprint(one_tree)
#
# # t = map2tree(one_tree, 'entity.n.01')
# # print t
# # t.draw()

count_map = dict(zip(words, num_word_synsets))

print "count_map: ", count_map

# print get_leaves(one_tree, 'vertebrate.n.01') # 'snake.n.05'; 'vertebrate.n.01'

# get_common_root(one_tree, 'vertebrate.n.01', count_map)

cr = get_common_root(one_tree, 'entity.n.01', count_map, len(words))
h = cr[0]
root_name = cr[1]
print 'commom root: ',root_name

print "tree: "
pprint(h)