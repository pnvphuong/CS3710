__author__ = 'nineil'

import csv
import json
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

def get_node_bifurcation(h, root_name): # descendent with more than 1 child
    # base case [leaf]
    childs = h[root_name][1:]
    if len(childs) > 1:
        return root_name
    else:
        return get_node_bifurcation(h, childs[0])

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

def compress_tree(h, root_name):
    childs = h[root_name]
    for i in range(1, len(childs)):
        child = childs[i]
        if h.has_key(child):
            nro_grand_childs = len(h[child]) - 1
            leave_nodes = get_leaves(h, child)

            if nro_grand_childs ==1 and len(leave_nodes) == 1: # leaf node
                # prune
                leave_node = leave_nodes
                childs[i] = leave_node[0] # [0]
                h[root_name] = childs # point to leaf node
            elif nro_grand_childs == 1: # For intermediate nodes
                node_bif = get_node_bifurcation(h, child)
                childs[i] = node_bif # TODO: later update with the less depth node, should need prune step later
                h[root_name] = childs
                compress_tree(h, node_bif)

                # remove intermediate nodes
                # while h.has_key(child):
                #     child = h[child][1]
                #     del h[child]
            else:
                compress_tree(h, child)

def get_deep(h, root_name, leave, depth_count):
    if h.has_key(root_name):
        vo = [];
        childs = h[root_name][1:]
        for child in childs:
            v = get_deep(h, child, leave, depth_count + 1)
            if v != -1:
                vo = vo + v
        return vo
    else:
        if root_name == leave:
            return [depth_count]
        else:
            return -1

def get_father(h, root_name, leave, father):
    if h.has_key(root_name):
        vo = [];
        childs = h[root_name][1:]
        for child in childs:
            v = get_father(h, child, leave, root_name)
            if v != -1:
                vo = vo + v
        return vo
    else:
        if root_name == leave:
            return [father]
        else:
            return -1

def select_node_meanings(h, root_name, count_vector):
    d = {};
    keys = count_vector.keys()

    for k in keys:
        if count_vector[k] > 1:
            v_deep = get_deep(h, root_name, k, 0)
            v_fathers = get_father(h, root_name, k, [])

            # get deepest node
            max_deep = max(v_deep)
            max_ix = v_deep.index(max_deep)
            father = v_fathers[max_ix]
            d[k] = [max_ix, father]
    return d

def refine_tree(h, root_name, s):
    if h.has_key(root_name): # no leave node
        childs = h[root_name]
        i = 1
        while i < len(childs):
            child = childs[i]
            if child in s:
                del childs[i]
                i -= 1
                h[root_name] = childs
            else:
                s.add(child)
                refine_tree(h, child, s)
            i += 1

def remove_dead_nodes(h, s):
    ks = h.keys()

    for k in ks:
        if not(k in s):
            del h[k]

def get_dead_leaves(h):
    ks = h.keys()
    vdl = []

    for k in ks:
        childs = h[k]
        if len(childs) == 1:
            vdl.append(k)
    return vdl

def remove_dead_leave(h, dl):
    ks = h.keys()

    for k in ks:

        # remove from childs
        childs = h[k]
        try:
            ix = childs.index(dl)
            del childs[ix]
            h[k] = childs
        except:
            print 'element not found!'

        # remove from keys
        if k == dl:
            del h[k]

def remove_dead_leaves(h, vdl):
    for dl in vdl:
        remove_dead_leave(h, dl);


# Trying to incorporate deep information, TODO: not working
def refine_tree2(h, root_name, conflict_nodes, d):

    if h.has_key(root_name): # no leave node
        childs = h[root_name]

        i = 0
        while i < len(childs):
        #for i in range(len(childs) - 1, 0, -1):
            child = childs[i]
            if child in conflict_nodes.keys():
                ix = conflict_nodes[child][0]
                father = conflict_nodes[child][1]

                if child in d.keys():
                    if ix != d[child]:
                        del childs[i]
                        i = i -1
                        h[root_name] = childs
                    else:
                        d[child] = d[child] + 1
                        refine_tree2(h, child, conflict_nodes, d)
                else:
                    if ix != 0:
                        del childs[i]
                        i = i -1
                        h[root_name] = childs
                    else:
                        d[child] = 1 # first ocurrence
                        refine_tree2(h, child, conflict_nodes, d)
            else:
                refine_tree2(h, child, conflict_nodes, d)
            i = i + 1

# trying to add grand_childs information, TODO: not working
def refine_tree3(h, root_name, conflict_nodes, s):
    if h.has_key(root_name): # no leave node
        childs = h[root_name]
        i = 1
        while i < len(childs):
            child = childs[i]
            if h.has_key(child):
                grand_childs = h[child]

                for j in range(1, len(grand_childs)):
                    grand_child = grand_childs[j]
                    if grand_child in conflict_nodes.keys():
                        if grand_child in s:
                            print "delete conflict"
                            del childs[i]
                            i = i - 1
                            h[root_name] = childs
                        else:
                            s.add(grand_child)
                            refine_tree(h, child, conflict_nodes, s)
                    else:
                        refine_tree(h, child, conflict_nodes, s)
            i = i + 1

def get_unique_synset(leaves, fathers, depths):
    vus = {}
    for i in range(len(depths)):
        father = fathers[i]
        leave = leaves[i]
        el = depths[i]
        max_el = max(el)
        ix_max = el.index(max_el)
        vus[leave] = wn.synset(father[ix_max])
    return vus

def create_sim_matrix(vector_data,  func_d):
    n = len(vector_data)
    v = np.empty([n, n])
    for i in range(n):
        di = vector_data[i]
        for j in range(n):
            dj = vector_data[j]
            d = func_d(di, dj)
            v[i,j] = d
    return v

def dm2vect(dm):
    (nr, nc) = dm.shape
    #superior diagonal
    m = np.triu(dm, k = 1)
    v = m.ravel()

    # diagonal
    v = v[v > 0]
    v = 1 - v # convert similarity to distance

    return v



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
print 'common root: ',root_name

leave_nodes = get_leaves(h, root_name)
print "leave_nodes: ", leave_nodes

get_father_leave= lambda x: get_father(h, root_name, x, [])
parents = map(get_father_leave, leave_nodes)
print "parents: ", parents

get_depth_leave = lambda x: get_deep(h, root_name, x, 0)
depths = map(get_depth_leave, leave_nodes)
print "depths: ", depths

us = get_unique_synset(leave_nodes, parents, depths)
pprint(us)

# create synset distance matrix
all_synsets = us.values();
# name_synsets = map(lambda x: str(x.name()), us.keys())
f_sim = lambda x, y: x.path_similarity(y) # 1 means are the same object

dm = create_sim_matrix(all_synsets,  f_sim)
distance_vector = dm2vect(dm)

print 'type dm: ', type(dm)
print 'len dm: ', dm.shape
# print 'dm: ', dm

class SetEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, np.ndarray):
            return list(obj)
        return json.JSONEncoder.default(self, obj)

dm = json.dumps(dm, cls=SetEncoder)
name_synsets = json.dumps(us.keys())

print "distance vector: ", len(distance_vector), distance_vector
print "name synsets: ", name_synsets

file_hierar = '../data/distances_hierarchy.txt';
leaves_hierar = '../data/leaves_hierarchy.txt';

f = open(file_hierar, 'w')
f.write(distance_vector)
f.close()

f = open(leaves_hierar, 'w')
f.write(name_synsets)
f.close()

