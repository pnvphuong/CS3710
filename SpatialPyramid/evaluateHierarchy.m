function confusionMatrix = evaluateHierarchy(nameHierarchy)
    addpath(genpath('classifier')); % add classifier
    addpath(genpath('taxonomy')); % add taxonomy
    addpath(genpath('../data'));
    baseFolder = '../data/256_ObjectCategories';
    % load feature vector
    load('feat_map.mat');
    % load Caltech256 taxonomy
    load('caltechTaxonomy.mat');
    featureMap = dataMap;
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
    categoryIdx = linspace(1, length(categoryList), length(categoryList));
    categoryMap = containers.Map(categoryList,categoryIdx);

    epoch = 40;
    epoch = 1;
    trainTestRatio = 0.3;
    
    for i = 1 : epoch
        sprintf('%d run',i)
        % set seed random number
        rng(i);
        % extract train, test list for this epoch
        % trainIDList with 43 items, each item contains a list of all
        % selected image.
        % the same category idx as in categoryList
        [trainIDList, testIDList] = extractTrainTestList(categoryList,...
            caltechTaxonomyMap,	trainTestRatio, baseFolder);
        % build classifier
        % predict
    end
end

% build hierarchy classifier using map
function hierarchyClassifier = buildHierarchyClassifier(K,nameHierarchy)
    categoryNameKey = keys(nameHierarchy);
    classifierList = cell(1,length(categoryNameKey));
    % each key contain a list of children, we build 1 vs all for these
    % children
    for iParent = 1 : length(nameHierarchy)
        sprintf('classifierName=%s', nameHierarchy{iParent})
        classifierNameList = categoryNameHierarchy(nameHierarchy{iParent});
        classifierList{iParent} = buildClassifierListFromNameList(classifierNameList,nameHierarchy);
    end
    hierarchyClassifier = containers.Map(categoryNameKey,classifierList);
end

% build 1 vs all classifier for this branch
% each classifierNameList element is a 1 vs all classifier
function classifierList = buildClassifierListFromNameList(classifierNameList,...
    categoryNameHierarchy)
    % analyze each classifierNameList element into atom category names
    individualNameList = cell(1,length(classifierNameList));
    for i = 1 : length(classifierNameList)
        individualNameList{i} = extractCategoryFromCategoryName(classifierNameList{i},...
            categoryNameHierarchy,{});
    end
    % extract train, test data
        % how to build 1 vs all automatically? buildLeafNodeClassifierList
        % filter trainIDList
        % compute kernel
        sprintf('\t\tcompute kernel')
        [K, KK, trainID, testID] = computeKernel(trainIDList,...
            testIDList, featureMap);
        % or only use data set within this branch? yes, recompute K for
        % each branch
end

function categoryList = extractCategoryFromCategoryName(categoryName,...
    categoryNameHierarchy, inCategoryList)
    categoryList = inCategoryList;
    if isKey(categoryNameHierarchy, categoryName) % non-terminal node
        childrenList = categoryNameHierarchy(categoryName);
        for i = 1 : length(childrenList)
            categoryList = extractCategoryFromCategoryName(childrenList{i},...
                categoryNameHierarchy, categoryList);
        end
    else % leaf node
        categoryList = [categoryList categoryName];
    end
end