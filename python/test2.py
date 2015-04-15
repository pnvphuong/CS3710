__author__ = 'nineil'

# dict = {'Name': 'Zara', 'Age': 7, 'Class': 'First'};
dict = {}

dict['Age'] = 8; # update existing entry
dict['School'] = "DPS School"; # Add new entry
dict['nineil'] = {"marleny": 0}; # Add new entry

print dict

for x in range(1, 3):
    print "We're on time %d" % (x)

y = [14, 52, 13]
print y[1:]

y.append([4, 3])
print y

print [5] * 2

# wordnet = ximport("wordnet")
# from wordnet import explode
# font("Georgia-BoldItalic", 10)
# fill(0.3)
# q = "container"
# explode.draw(q, wordnet.noun_hyponyms(q), 300, 300, max=30)

from nltk.tree import *
from nltk.draw import tree

dp1 = Tree('dp', [Tree('d', ['the']), Tree('np', ['dog'])])
dp2 = Tree('dp', [Tree('d', ['the']), Tree('np', ['cat'])])
vp = Tree('vp', [Tree('v', ['chased']), dp2])
sentence = Tree('s', [dp1, vp])
print sentence

sentence.draw()

print range(5)
print range(1, 5)