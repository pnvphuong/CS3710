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
    categoryIdx = (1 : length(categoryList));
    categoryMap = containers.Map(categoryList,categoryIdx);

    epoch = 40;
    epoch = 1;
    trainTestRatio = 0.3;
    
    confusionMatrixList = cell(1,epoch);
    accList = zeros(1,epoch);
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
        sprintf('build')
        [hierarchyClassifier, hierarchyTrainSet] = buildHierarchyClassifier(...
            nameHierarchy,trainIDList,categoryMap,featureMap);
        % evaluate/predict the test set
        sprintf('predict')
        confusionMatrix = evaluateHierarchyClassifier(testIDList,...
            hierarchyClassifier, hierarchyTrainSet,featureMap,nameHierarchy,...
            categoryMap,categoryList);
        confusionMatrixList{i} = confusionMatrix;
        accList(i) = trace(confusionMatrix) / sum(sum(confusionMatrix));
        save('../data/confusionMatrixHierarchy.mat', 'confusionMatrixList');
    end
    sprintf('avg Acc=%f',sum(accList) / epoch)
end

% build hierarchy classifier using map, i.e. a 1vsAll classifier for each
% key of the map nameHierarchy
function [hierarchyClassifier, hierarchyTrainSet] =...
    buildHierarchyClassifier(nameHierarchy,trainIDList,categoryMap,featureMap)
    categoryNameKey = keys(nameHierarchy);
    classifierList = cell(1,length(categoryNameKey));
    trainSetList = cell(size(classifierList));
    % each key contain a list of children, we build 1 vs all for these
    % children
    for iParent = 1 : length(categoryNameKey)
        % sprintf('classifierName=%s', categoryNameKey{iParent})
        classifierNameList = nameHierarchy(categoryNameKey{iParent});
        [classifierList{iParent}, trainSetList{iParent}] =...
            buildClassifierListFromNameList(classifierNameList,...
            nameHierarchy,trainIDList,categoryMap, featureMap);
    end
    hierarchyClassifier = containers.Map(categoryNameKey,classifierList);
    hierarchyTrainSet = containers.Map(categoryNameKey,trainSetList);
end

% build 1 vs all classifier for this branch
% each classifierNameList element is a 1 vs all classifier
function [classifierList, branchTrainIDList] = buildClassifierListFromNameList(...
    classifierNameList,categoryNameHierarchy, trainIDList, categoryMap,...
    featureMap)
    % analyze each classifierNameList element into atom category names
    individualNameList = cell(1,length(classifierNameList));
    for i = 1 : length(classifierNameList)
        individualNameList{i} = extractCategoryFromCategoryName(...
            classifierNameList{i}, categoryNameHierarchy,{});
    end    
    % get trainIDList for this branch (all children's atom names)
    branchTrainIDList = {};    
    for i = 1 : length(individualNameList)
        individualName = individualNameList{i};
        for j = 1 : length(individualName)
            branchTrainIDList = [branchTrainIDList {trainIDList{...
                categoryMap(individualName{j})}}];            
        end
    end
    
    % compute kernel
    K = computeSingleKernel(branchTrainIDList,featureMap);
%     save('../data/testK.mat','K');
%   load('../data/testK.mat');    
    % build branch 1vsall classifier
    classifierList = buildBranch1vsAllClassifier(K,trainIDList,...
        individualNameList,categoryMap);
end

function classifierList = buildBranch1vsAllClassifier(K,trainIDList,...
    individualNameList, categoryMap)
    classifierList = cell(1, length(individualNameList));
    for i = 1 : length(classifierList)
        classValue = getBranchClassValue(individualNameList, trainIDList,...
            categoryMap,i);
        classifierList{i} = buildBinaryClassifier(K, classValue);
    end
end

function classValue = getBranchClassValue(individualNameList, trainIDList,...
    categoryMap, iCategory)
	classValue = [];
	for i = 1 : length(individualNameList)
        len = 0;
        individualName = individualNameList{i};
        for j = 1 : length(individualName)
            len = len + length(trainIDList{categoryMap(individualName{j})});
        end
		categoryClassValue = ones(len,1);
		if i ~= iCategory
			% negative class
			categoryClassValue = categoryClassValue .* -1;
		end

		classValue = [classValue; categoryClassValue];
	end
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

function K = computeSingleKernel(imageIDList, featureMap)
    [trainFeatureTable, trainID] = getFeatureList(imageIDList, featureMap);

	k = hist_isect(trainFeatureTable, trainFeatureTable);
	K = [ (1:size(trainFeatureTable,1))' , k ];
end

function [featureList, id] = getFeatureList(idList, featureMap)
	id = [];
	for i = 1 : length(idList)
		id = [id; idList{i}];
	end
	id = cellstr(id);

	featureList = getFeatureFromID(featureMap, id);
end

function featureList = getFeatureFromID(featureMap, idList)
	featureList = [];
	for i = 1 : length(idList)
		featureList = [featureList; featureMap(idList{i})];
	end
end

% evaluate hierarchy 
function confusionMatrix = evaluateHierarchyClassifier(testIDList,...
    hierarchyClassifier, hierarchyTrainSet,featureMap,nameHierarchy,...
    categoryMap,categoryList)
    totalTestImage = 0;
    for i = 1 : length(testIDList)
        totalTestImage = totalTestImage + length(testIDList{i});
    end
    confusionMatrix = zeros(length(categoryMap));
    iCount = 1;
    % different image has different hierarchy path
    for iTest = 1 : length(testIDList)
        subTestID = testIDList{iTest};
        for jTest = 1 : length(subTestID)
            sprintf('predict %d/%d image',iCount,totalTestImage)
            testID = subTestID{jTest};            
            predCategoryName = predictImage(testID,hierarchyClassifier,...
                hierarchyTrainSet,featureMap,nameHierarchy);
            testNameIdx = iTest; % use in the confusion matrix
            % update confusion matrix
            % row = target; col = prediction
            confusionMatrix(testNameIdx,categoryMap(predCategoryName)) =...
                confusionMatrix(testNameIdx,categoryMap(predCategoryName))+1;
            iCount = iCount + 1;            
        end
    end
end

% predict category name for an image
function predCategoryName = predictImage(testID,hierarchyClassifier,...
    hierarchyTrainSet,featureMap,nameHierarchy)
    % go through the hierarchy (recursive) by starting at the root, the
    % longest node name
    nodeNameList = keys(nameHierarchy);
    nodeNameLengthList = cellfun(@length, nodeNameList);
    rootNode = nodeNameList{find(nodeNameLengthList == max(nodeNameLengthList))};
    % predict category name of this testID image
    predCategoryName = predictHierarchyClassifier(testID,hierarchyClassifier,...
        hierarchyTrainSet,rootNode,featureMap,nameHierarchy);
end

% recursive predict the image
function predName = predictHierarchyClassifier(testID,hierarchyClassifier,...
    hierarchyTrainSet,nodeName,featureMap,nameHierarchy)
%     sprintf('nodeName=%s',nodeName)
    classifierList = hierarchyClassifier(nodeName);
    trainIDList = hierarchyTrainSet(nodeName);
    categoryNameList = nameHierarchy(nodeName);
    % compute kernel
    KK = computeTestKernel(trainIDList,testID,featureMap);
    predClass = predictMulticlassInstance(KK, classifierList);
    [row,col] = find(predClass == 1);   
    subNodeName = categoryNameList{col(1)}; % col has only 1 value
    % is non-terminal?
    if isKey(nameHierarchy,subNodeName)
        predName = predictHierarchyClassifier(testID,hierarchyClassifier,...
            hierarchyTrainSet,subNodeName,featureMap,nameHierarchy);
    else
        predName = subNodeName;
    end
end

function KK = computeTestKernel(trainIDList, testID, featureMap)
    [trainFeatureTable, trainID] = getFeatureList(trainIDList, featureMap);
	k = hist_isect(featureMap(testID), trainFeatureTable);
	KK = [ (1:size(testID,1))' , k ];
end

% predict test image, output the prediction index according to categoryName
function predClass = predictMulticlassInstance(KK, classifierList)
    % prediction probability on each class
	predProb = zeros(size(KK,1), length(classifierList));
    classVector = ones(size(predProb,1),1);
    for iCategory = 1 : length(classifierList)
		% get prediction probability
		decVals = predictBinaryClassifier(KK, classVector, classifierList{iCategory});
		% merge into the prediction matrix
		predProb(:,iCategory) = decVals(:,find(classifierList{iCategory}.Label == 1));
	end
	% find the maximum prediction probability for each test image
	mx = max( predProb, [], 2 ); % max probability in each row
	% prediction class for each test image with tie breaker
	% only keep the first maximum probability
	predClass = tieBreaker(bsxfun(@eq, predProb,mx));
end

function tieBreakVector = tieBreaker(inputVector)
	tieBreakVector = inputVector;
	for i = 1 : size(tieBreakVector,1)
		rowSum = sum(tieBreakVector(i,:));
		if  rowSum > 1
			for j = 1 : length(tieBreakVector(i,:))
				if tieBreakVector(i,length(tieBreakVector(i,:)) - j + 1) ~= 0
					tieBreakVector(i,length(tieBreakVector(i,:)) - j + 1) = 0;
					rowSum = rowSum - 1;
					if rowSum == 1
						break;
					end
				end
			end
		end
	end
end