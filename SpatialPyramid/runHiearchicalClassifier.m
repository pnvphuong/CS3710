clear;
addpath(genpath('classifier')); % add classifier
addpath(genpath('taxonomy')); % add taxonomy
addpath(genpath('../data'));
addpath(genpath('hierarchical'));

load('caltechTaxonomy.mat');

% use map object
load('feat_map.mat');
featureMap = dataMap;
% baseFolder = '../data/256_ObjectCategories'; % phuong
% baseFolder = 'D:\datasets\256_ObjectCategories'; % Nils PC
baseFolder = '/afs/cs.pitt.edu/usr0/nineil/private/datasets/256_ObjectCategories'; % Nils Server
% baseFolder = 'E:\nineil\phd\general_datasets\256_ObjectCategories'; % Nils PC Lab
trainTestRatio = 0.3;
epoch = 40;

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

% Toy taxonomy
keySet =   {'animal', 'air', 'land', 'ibis', 'hawksbill', 'bat', 'bear'};
valueSet = {{'air', 'land'}, {'ibis', 'hawksbill'}, {'bat', 'bear'}, ...
            '114.ibis-101', '100.hawksbill-101', '007.bat', '009.bear'};
tax2 = containers.Map(keySet,valueSet);

% tax = tax2;
tax = caltechTaxonomyMap;

evaluationTableHierar = cell(1,epoch);
accList = zeros(1, epoch);
for iRun = 1 : epoch
	fprintf('run %d\n', iRun);
    
	% set seed random number
	rng(iRun);
    
	% extract train, test set
	fprintf('\textract train, test sets\n');
    map_IDList = extractTrainTestList_hierarchy('animal', tax, trainTestRatio, baseFolder, '   ');
    
    % refine hierarchy
    fprintf('\trefine hierarchy\n');
    refined_IDList = refineMap_IDList(map_IDList, tax );
                        
	% compute kernel, and get id (filename) of train set, test set
	fprintf('\tcompute kernels\n');
    map_kernels = computeKernel_hierarchy( refined_IDList, featureMap);
    
	% build classifier list
	fprintf('\ttrain classifier list\n');
	map_learned_models = buildClassifierHierarchy( map_kernels, refined_IDList);
    
	% predict
	fprintf('\tevaluate classifier list\n');
    r = refined_IDList('animal');
    predictions = predictClassifierHierarchy('animal', map_kernels, r{2}, map_learned_models, featureMap, tax);
    % map_predictions = predictClassifierHierarchy( map_kernels, refined_IDList, map_learned_models);
	% evaluationTable{iRun} = predictLeafNodeClassifierList(KK, testID, testIDList, classifierList);
    disp('Size Predictions:')
    size(predictions)
    
    % get ground truths,
    gt = getGroundTruth_manual(r{2});
    disp('Size GroundTruth:')
    size(gt)
    
    % evaluation
    evaluationTableHierar{iRun} = {gt, predictions};
    eval = classperf(gt, predictions);
	accList(iRun) = eval.CorrectRate;
	save('../data/evaluationTableHierar.mat', 'evaluationTableHierar');
end
save('../data/accList.mat', 'accList');
disp(sprintf('Avg acc = %f', sum(accList) / epoch))