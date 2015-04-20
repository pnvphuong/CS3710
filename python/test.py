__author__ = 'nineil'


# #**************** TEST1
# from nltk.corpus import wordnet as wn
#
# # SEE: http://www.nltk.org/howto/wordnet.html
# #main
# print 'test0: ', wn.synsets('dog')
# print 'test1: ', wn.synsets('dog')
#
# # import nltk
# # nltk.download()
#
# print 'test2: ', wn.synset('woman.n.01').lowest_common_hypernyms(wn.synset('girlfriend.n.02'))
# print(wn.morphy('dogs'))
# print(wn.morphy('horseshoe-crab')) # None
# print(wn.morphy('killer-whale')) # None
#
# # print wn.synset('woman').lowest_common_hypernyms(wn.synset('girlfriend'))


# #********* TEST2
# import scipy.io
#
# # read taxonomy matlab file
# tax_file = 'leaves.mat';
# mat = scipy.io.loadmat(tax_file); # data type: dictionary
# # print mat
# print type(mat)
#
# # print 'Keys: ', mat.keys()
# # print 'Items: ', mat.items()
#
# v = mat['vl']
#
# # print 'vl: ', v
# print 'class - vl: ', type(v)
# print 'shape - vl: ', v.shape
#
# print 'test: ', v[0]


# # ************* TEST3
# from nltk.corpus import wordnet as wn
# from pprint import pprint
#
# # transform list to a tree [dictionary]
#
# dog = wn.synset('dog.n.01')
# # dog = wn.synset('cricket_bat.n.01')
# print 'synsets: ', dog
# hyp = lambda s:s.hypernyms()
# r = dog.tree(hyp)
#
# bat = wn.synset('cricket_bat.n.01')
# print 'synsets: ', bat
# hyp = lambda s:s.hypernyms()
# r2 = bat.tree(hyp)
#
# # pprint(r, indent=2)
# pprint(r, indent=3)
# print r, '\n', type(r), '\n', len(r)
# print r[0]
# print r[0].name()
# print len(r[1]), r[1]
# # print len(r[2]), r[2]
#
# # Function transform list to tree, It generates bottom-up Tree
# def list2map(list_vector, dict):
#     # base case
#     root = str(list_vector[0].name())
#     childs = []
#     for i in range(1, len(list_vector)):
#         el = list_vector[i][0]
#         el = str(el.name())
#         childs.append(el)
#
#     if dict.get(root) != None:
#         dict[root][0] = dict[root][0] + 1 # update count
#     else:
#         if len(childs) == 0:
#             v= [1] # This is for the root node
#         else:
#             v = [len(childs)] # everyone starts with count 1
#         for i in range(len(childs)):
#             v.append(childs[i])
#         dict[root] = v
#
#     # print
#     # print 'root: ', root
#     # print 'childs: ', childs
#     # print 'dict: ', dict
#
#     # recursion step
#     for i in range(1, len(list_vector)):
#         list2map(list_vector[i], dict)
#
# # Function reverse a tree
# def reverse_tree(dict, root, dict_out):
#     # base case
#     childs = dict[root]
#     for i in range(1, len(childs)):
#         child = childs[i]
#         if dict_out.get(child) == None:
#             count_child = dict[child][0]
#             dict_out[child] = [count_child, root]
#         else:
#             if not(root in dict_out[child]):
#                 dict_out[child].append(root)
#
#     # recursive case
#     for i in range(1, len(childs)):
#         child = childs[i]
#         reverse_tree(dict, child, dict_out)
#
# # Merge two trees
# def merge_trees(d1, d2):
#     ds = dict(d2)
#     for k in d1.keys():
#         if d1.get(k) != None and ds.get(k) != None:
#             c = ds[k][0] + d1[k][0] # merge count
#             l1 = ds[k][1:]
#             l2 = d1[k][1:]
#             lr = [c] + list(set(l1+l2))
#             ds[k] = lr
#             # merge nodes
#         elif d1.get(k) != None and ds.get(k) == None:
#             ds[k] = d1[k] # add a new node
#     return ds
#
#
# # tests
# d = {}
# list2map(r, d)
# d2 = {}
# reverse_tree(d, 'dog.n.01', d2)
#
# print "d2: ", d2
# pprint(d2)
#
# da = {}
# list2map(r2, da)
# db = {}
# reverse_tree(da, 'cricket_bat.n.01', db)
#
# print "db: ", db
# pprint(db)
#
# ds = merge_trees(d2, db)
# print "ds: ",ds
# pprint(ds)
# pprint(db)
#
# from collections import Counter
# z = ['blue', 'red', 'blue', 'yellow', 'blue', 'red']
# print 'a' in z
# c = Counter(z)


# # ************* TEST4
# import json
#
# dict = {"hello": "world"}
# x = json.dumps(dict)
#
# f = open('test.txt', 'w')
# f.write(x)
#
#
# childs = [1, 'ss', 'ww'];
# try:
#     print childs.index('sww')
# except:
#     print "not found"
#
# del childs[0]
# print childs

# # **************** TEST 5
# # import numpy as np
# from numpy import array
# from scipy.spatial.distance import pdist
#
# x = array([[0,10],[10,10],[20,20], [30,30]])
# y = pdist(x)
#
# print "x: ", x
# print "pdist: ", y

import numpy as np

mat = np.array([[1,2,3],[4,5,6],[7,8,9]])
print np.tril(mat)
t2 = np.triu(mat, k =1)
print t2
print t2.ravel()
print t2[t2 > 0]

from nltk.corpus import wordnet_ic
from nltk.corpus import wordnet as wn

brown_ic = wordnet_ic.ic('ic-brown.dat')

dog = wn.synset('dog.n.01')
cat = wn.synset('cat.n.01')
hit = wn.synset('hit.n.01')
slap = wn.synset('slap.n.01')

print "cat-cat:", cat.res_similarity(cat, brown_ic) # Higher value if the are mos the same
print "dog-dog:", dog.res_similarity(dog, brown_ic)
print "hit-hit:", hit.res_similarity(hit, brown_ic)
print "slap-slap:", slap.res_similarity(slap, brown_ic)

print "cat-dog:", cat.res_similarity(dog, brown_ic)
print "cat-hit:", cat.res_similarity(hit, brown_ic)