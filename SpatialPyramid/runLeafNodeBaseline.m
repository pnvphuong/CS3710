clear;
addpath(genpath('classifier')); % add classifier
addpath(genpath('taxonomy')); % add taxonomy
addpath(genpath('../data'));

load('caltechTaxonomy.mat');
%% use table object
% load('feat_data.mat');
% use map object
load('feat_map.mat');
featureMap = dataMap;
% baseFolder = '../data/256_ObjectCategories';
baseFolder = '/afs/cs.pitt.edu/usr0/nineil/private/datasets/256_ObjectCategories';
trainTestRatio = 0.3;
epoch = 1; % 40

% full list of leaf node in the Animal tree
% categoryList = {'ibis', 'hawksbill', 'hummingbird', 'cormorant', 'duck', ...
%     'goose', 'ostrich', 'owl', 'penguin', 'swan', ...
%     'bat', 'bear', 'camel', 'chimp', 'dog', 'elephant', ...
%     'elk', 'frog', 'giraffe', 'goat', 'gorilla', ...
%     'horse', 'iguana', 'kangaroo', 'llama', ...
%     'leopards', 'porcupine', 'raccoon', 'skunk', ...
%     'snake', 'snail', 'zebra', 'greyhound', 'toad', ...
%     'horseshoe-crab', 'crab', 'conch', 'dolphin', ...
%     'goldfish', 'killer-whale', 'mussels', 'octopus', 'starfish'};
categoryList = {'ibis', 'hawksbill', 'hummingbird'};
% categoryList = {'ibis', 'hawksbill'};

evaluationTable = cell(1,epoch);
accList = zeros(1, epoch);
for iRun = 1 : epoch
	disp(sprintf('run %d', iRun))
	% set seed random number
	rng(iRun);
	% extract train, test set
	disp(sprintf('\textract train, test sets'))
	[trainIDList, testIDList] = extractTrainTestList(categoryList, caltechTaxonomyMap,...
							trainTestRatio, baseFolder);
    trainIDList
	% compute kernel, and get id (filename) of train set, test set
	disp(sprintf('\tcompute kernels'))
	[K, KK, trainID, testID] = computeKernel(trainIDList, testIDList, featureMap);
	% build classifier list
	disp(sprintf('\ttrain classifier list'))
	classifierList = buildLeafNodeClassifierList(K, trainIDList)
	% predict
	disp(sprintf('\tevaluate classifier list'))
	evaluationTable{iRun} = predictLeafNodeClassifierList(KK, testID, testIDList, classifierList);	
	accList(iRun) = getPerformance(evaluationTable{iRun});
	save('../data/evaluationTable.mat', 'evaluationTable');
end
save('../data/accList.mat', 'accList');
disp(sprintf('Avg acc = %f', sum(accList) / epoch))