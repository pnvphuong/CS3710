clear;
addpath(genpath('classifier')); % add classifier
addpath(genpath('taxonomy')); % add taxonomy
addpath(genpath('../data'));
addpath(genpath('hierarchical'));

load('caltechTaxonomy.mat');
tax = caltechTaxonomyMap;

% use map object
load('feat_map.mat');
featureMap = dataMap;
% baseFolder = '../data/256_ObjectCategories'; % phuong
baseFolder = 'D:\datasets\256_ObjectCategories'; % Nils PC
% baseFolder = '/afs/cs.pitt.edu/usr0/nineil/private/datasets/256_ObjectCategories'; % Nils Server
% baseFolder = 'E:\nineil\phd\general_datasets\256_ObjectCategories'; % Nils PC Lab
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
% categoryList = {'ibis', 'hawksbill', 'hummingbird'};

% Toy taxonomy
keySet =   {'animal', 'air', 'land', 'ibis', 'hawksbill', 'bat', 'bear'};
valueSet = {{'air', 'land'}, {'ibis', 'hawksbill'}, {'bat', 'bear'}, ...
            '114.ibis-101', '100.hawksbill-101', '007.bat', '009.bear'};
tax2 = containers.Map(keySet,valueSet)

evaluationTable = cell(1,epoch);
accList = zeros(1, epoch);
for iRun = 1 : epoch
	fprintf('run %d', iRun);
    
	% set seed random number
	rng(iRun);
    
	% extract train, test set
	fprintf('\textract train, test sets');
    map_IDList = extractTrainTestList_hierarchy('animal', tax2, trainTestRatio, baseFolder, '   ');
    
    % refine hierarchy
    fprintf('\trefine hierarchy');
    refined_IDList = refineMap_IDList(map_IDList, tax2 );
                        
	% compute kernel, and get id (filename) of train set, test set
	disp(sprintf('\tcompute kernels'))
    map_kernels = computeKernel_hierarchy( refined_IDList, featureMap);
    
	% build classifier list
	disp(sprintf('\ttrain classifier list'))
	map_learned_models = buildClassifierHierarchy( map_kernels, refined_IDList);
    
	% predict
	disp(sprintf('\tevaluate classifier list'))
    r = map_IDList('animal');
    predictions = predictClassifierHierarchy('animal', map_kernels, r{2}, map_learned_models, featureMap, tax2);
    % map_predictions = predictClassifierHierarchy( map_kernels, refined_IDList, map_learned_models);
	% evaluationTable{iRun} = predictLeafNodeClassifierList(KK, testID, testIDList, classifierList);
    
    % get ground truths,
    gt = getGroundTruth( r{2} , categoryList);
    
    % evaluation
	accList(iRun) = getPerformance(evaluationTable{iRun});
	save('../data/evaluationTable.mat', 'evaluationTable');
end
save('../data/accList.mat', 'accList');
disp(sprintf('Avg acc = %f', sum(accList) / epoch))