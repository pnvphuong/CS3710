clear;
addpath(genpath('classifier')); % add classifier
addpath(genpath('taxonomy')); % add taxonomy
addpath(genpath('../data'));

load('caltechTaxonomy.mat');
%% use table object
% load('feat_data.mat');
% use map object
load('feat_map.mat');
featureTableMap = dataMap;
baseFolder = '../data/256_ObjectCategories';
trainTestRatio = 0.3;
epoch = 1;

% full list of leaf node in the Animal tree
categoryList = {'ibis', 'hawksbill', 'hummingbird', 'cormorant', 'duck', ...
    'goose', 'ostrich', 'owl', 'penguin', 'swan', ...
    'bat', 'bear', 'camel', 'chimp', 'dog', 'elephant', ...
    'elk', 'frog', 'giraffe', 'goat', 'gorilla', ...
    'horse', 'iguana', 'kangaroo', 'llama', ...
    'leopards', 'porcupine', 'raccoon', 'skunk', ...
    'snake', 'snail', 'zebra', 'greyhound', 'toad', ...
    'horseshoe-crab', 'crab', 'conch', 'dolphin', ...
    'goldfish', 'killer-whale', 'mussels', 'octopus', 'starfish'};
categoryList = {'ibis', 'hawksbill'};

for iRun = 1 : epoch
	% set seed random number
	rng(iRun);
	% extract train, test set
	[trainIDList, testIDList] = extractTrainTestList(categoryList, caltechTaxonomyMap,...
							featureTableMap, trainTestRatio, baseFolder);

	classifierList = 
end