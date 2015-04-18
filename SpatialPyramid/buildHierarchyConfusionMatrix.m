function confusionMatrix = buildHierarchyConfusionMatrix()
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

    N = length(categoryMap);

    confusionMatrix = zeros(N,N);

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
        % leave one out train and predict        
        for iLeave = 1 : N
            sprintf('\tevaluate %s',categoryList{iLeave})
            % idx order of filterCategoryName, filterTrainID, filterTestID
            % are the same
%             sprintf('\t\tfilter training data')
            [filterCategoryName, filterTrainID, filterTestID] =...
                leaveOneCategoryOut(categoryList,trainIDList,testIDList,iLeave);
            filterCategoryName
            filterTestID = {trainIDList{iLeave}};
            % compute kernel
%             sprintf('\t\tcompute kernel')
            [K, KK, trainID, testID] = computeKernel(filterTrainID,...
                filterTestID, featureMap);
%           save('../data/testK.mat','K','KK');
%           load('../data/testK.mat');
            % build N - 1 1vsAll classifier from this filter list
%             sprintf('\t\tbuild classifiers')
            classifierList = buildMulticlassClassifier(filterTrainID,K);
            % predict the left out image set
%             sprintf('\t\tpredict')
            predClass = predictMulticlassInstance(KK, classifierList);
            % convert predict idx into category name
            predCategoryName = convertIdx2Name(predClass,filterCategoryName);
            % update confusion matrix
%             sprintf('\t\tupdate confusion matrix')
            confusionMatrix = updateConfusionMatrix(predCategoryName,...
                categoryMap,confusionMatrix,iLeave)
        end
    end
    % average
    confusionMatrix = confusionMatrix ./ N;

    % save result
    save('../data/hierarchyConfusionMatrix.mat', 'confustionMatrix');
end

% leave one out filtering
function [filterCategoryName, filterTrainID, filterTestID] =...
    leaveOneCategoryOut(categoryList,trainIDList, testIDList, iLeave)
    filterCategoryName = cell(1, length(categoryList) - 1);
    filterTrainID = cell(1, length(filterCategoryName));
    filterTestID = cell(1, length(filterCategoryName));
    iName = 1;
    for i = 1 : length(categoryList)
        if i == iLeave
            continue;
        end
        filterCategoryName{iName} = categoryList{i};
        filterTrainID{iName} = trainIDList{i};
        filterTestID{iName} = testIDList{i};
        iName = iName + 1;
    end
end

% build 1 vs all classifiers
function classifierList = buildMulticlassClassifier(filterTrainID,K)
    classifierList = cell(1,length(filterTrainID));
   
    % train each 1vsAll classifier
    for i = 1 : length(classifierList)
        % create the class value vector
        classValue = getClassValue(filterTrainID, i);
        % train
        classifierList{i} = buildBinaryClassifier(K, classValue);
    end
end

function classValue = getClassValue(trainIDList, iCategory)
	classValue = [];
	for i = 1 : length(trainIDList)
		categoryClassValue = ones(length(trainIDList{i}),1);
		if i ~= iCategory
			% negative class
			categoryClassValue = categoryClassValue .* -1;
		end

		classValue = [classValue; categoryClassValue];
	end
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

function predCategoryName = convertIdx2Name(predClass,filterCategoryName)
    % convert prediction matrix into idx vector
    [row,col] = find(predClass == 1);
    [b,i] = sort(row);
    predVector = col(i);
    predCategoryName = cell(1,length(predVector));
    for i = 1 : length(predCategoryName)
        predCategoryName{i} = filterCategoryName{predVector(i)};
    end
end

% update the confusion matrix
function confusionMatrix = updateConfusionMatrix(predCategoryName,...
                categoryMap,inConfusionMatrix,iLeave)
    confusionVector = zeros(1,size(inConfusionMatrix,2));
    for i = 1 : length(predCategoryName)
        confusionVector(categoryMap(predCategoryName{i})) =...
            confusionVector(categoryMap(predCategoryName{i})) + 1;
    end
    % avg
    confusionVector = confusionVector ./ length(predCategoryName);
    confusionMatrix = inConfusionMatrix;
    confusionMatrix(iLeave, :) = confusionVector;
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