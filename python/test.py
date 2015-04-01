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


# ************* TEST3
from nltk.corpus import wordnet as wn
from pprint import pprint

# transform list to a tree [dictionary]

dog = wn.synset('dog.n.01')
# dog = wn.synset('cricket_bat.n.01')
print 'synsets: ', dog
hyp = lambda s:s.hypernyms()
r = dog.tree(hyp)

bat = wn.synset('cricket_bat.n.01')
print 'synsets: ', bat
hyp = lambda s:s.hypernyms()
r2 = bat.tree(hyp)

# pprint(r, indent=2)
pprint(r, indent=3)
print r, '\n', type(r), '\n', len(r)
print r[0]
print r[0].name()
print len(r[1]), r[1]
# print len(r[2]), r[2]

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
    ds = dict(d2)
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

# tests
d = {}
list2map(r, d)
d2 = {}
reverse_tree(d, 'dog.n.01', d2)

print "d2: ", d2
pprint(d2)

da = {}
list2map(r2, da)
db = {}
reverse_tree(da, 'cricket_bat.n.01', db)

print "db: ", db
pprint(db)

ds = merge_trees(d2, db)
print "ds: ",ds
pprint(ds)
pprint(db)