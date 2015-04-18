% paths
addpath(genpath('../../data/'));

dist_file = 'distances_hierarchy.txt';
leaves_file = 'leaves_hierarchy.txt';
h = sim2hierar(dist_file, leaves_file);