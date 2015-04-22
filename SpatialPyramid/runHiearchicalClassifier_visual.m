clear;
addpath(genpath('classifier')); % add classifier
addpath(genpath('taxonomy')); % add taxonomy
addpath(genpath('../data'));
addpath(genpath('hierarchical'));

% load sim hierarchy
load('euclideanNameHierarchy.mat');
h_sim = euclideanCategoryNameHierarchy;

load('caltechTaxonomy.mat');
mn = get_map_names(caltechTaxonomyMap);
root_name = 'starfish-hummingbird-bat-cormorant-killer-whale-dolphin-swan-greyhound-conch-horseshoe-crab-leopards-duck-snail-hawksbill-camel-goldfish-ibis-goose-octopus-giraffe-ostrich-owl-crab-horse-penguin-kangaroo-dog-llama-goat-zebra-bear-elk-elephant-skunk-snake-iguana-chimp-porcupine-raccoon-toad-gorilla-mussels-frog';
out_file = 'accList_visual.mat';
out_hierar = 'evaluationTableHierar_visual.mat';

% update leave nodes with names of the caltech hierarchy
% and erase leave nodes that are don't have any child related to the
% taxonomy
ks = keys(h_sim);

for i = 1: length(ks)
    k = ks{i};
    childs = h_sim(k); % cell array
    for j = 1 : length(childs)       
        val = childs{j};
        if isempty(findstr(val, '-')) % not from wordnet
            h_sim(val) = mn(val); % add a new node
        else
            if strcmp(val, 'horseshoe-crab') | strcmp(val, 'killer-whale')
                h_sim(val) = mn(val); % add a new node
            end
        end
    end
end

% use map object
load('feat_map.mat');
featureMap = dataMap;
% baseFolder = '../data/256_ObjectCategories'; % phuong
% baseFolder = 'D:\datasets\256_ObjectCategories'; % Nils PC
baseFolder = '/afs/cs.pitt.edu/usr0/nineil/private/datasets/256_ObjectCategories'; % Nils Server
% baseFolder = 'E:\nineil\phd\general_datasets\256_ObjectCategories'; % Nils PC Lab
trainTestRatio = 0.3;
epoch = 1; % 40

tax = h_sim;

evaluationTableHierar = cell(1,epoch);
accList = zeros(1, epoch);
for iRun = 1 : epoch
	fprintf('run %d\n', iRun);
    
	% set seed random number
	rng(iRun);
    
	% extract train, test set
	fprintf('\textract train, test sets\n');
    map_IDList = extractTrainTestList_hierarchy(root_name, tax, trainTestRatio, baseFolder, '   ');
    
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
    r = refined_IDList(root_name);
    predictions = predictClassifierHierarchy(root_name, map_kernels, r{2}, map_learned_models, featureMap, tax);
    % map_predictions = predictClassifierHierarchy( map_kernels, refined_IDList, map_learned_models);
	% evaluationTable{iRun} = predictLeafNodeClassifierList(KK, testID, testIDList, classifierList);
%     disp('Size Predictions:')
%     size(predictions)
    
    % get ground truths,
    gt = getGroundTruth_manual(r{2});
%     disp('Size GroundTruth:')
%     size(gt)
    
    % evaluation
    evaluationTableHierar{iRun} = {gt, predictions};
    eval = classperf(gt, predictions);
	accList(iRun) = eval.CorrectRate;
end
save(['../data/' out_hierar], 'evaluationTableHierar');
save(['../data/' out_file], 'accList');
disp(sprintf('Avg acc = %f', sum(accList) / epoch))