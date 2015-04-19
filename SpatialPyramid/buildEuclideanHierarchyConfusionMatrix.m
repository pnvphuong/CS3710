function confusionMatrix = buildEuclideanHierarchyConfusionMatrix()
    addpath(genpath('taxonomy')); % add taxonomy
    addpath(genpath('../data'));
    baseFolder = '../data/256_ObjectCategories';
    % load feature vector
    load('feat_map.mat');
    % load Caltech256 taxonomy
    load('caltechTaxonomy.mat');
    featureMap = dataMap;
    % full list of leaf node in the Animal tree
%     categoryList = {'ibis', 'hawksbill', 'hummingbird', 'cormorant', 'duck', ...
%         'goose', 'ostrich', 'owl', 'penguin', 'swan', ...
%         'bat', 'bear', 'camel', 'chimp', 'dog', 'elephant', ...
%         'elk', 'frog', 'giraffe', 'goat', 'gorilla', ...
%         'horse', 'iguana', 'kangaroo', 'llama', ...
%         'leopards', 'porcupine', 'raccoon', 'skunk', ...
%         'snake', 'snail', 'zebra', 'greyhound', 'toad', ...
%         'horseshoe-crab', 'crab', 'conch', 'dolphin', ...
%         'goldfish', 'killer-whale', 'mussels', 'octopus', 'starfish'};
    categoryList = {'duck', 'goose', 'ostrich', 'owl'};    
    N = length(categoryList);

    confusionMatrix = zeros(N,N);

    imgIDList = extractImgID(categoryList, caltechTaxonomyMap, baseFolder);
    
    for i = 1 : length(categoryList) - 1
        for j = i + 1 : length(categoryList)
            confusionMatrix(i,j) = getCategoryDistance(imgIDList{i},...
                imgIDList{j},featureMap);
            confusionMatrix(j,i) = confusionMatrix(i,j);
        end
    end
    confusionMatrix = confusionMatrix .* -1 % make the most confused items have the highest point
end

% get distance between 2 group, i.e. avg distance between pairs
function avgDistance = getCategoryDistance(category1, category2, featureMap)
    distanceList = [];
    for i = 1 : length(category1)
        feature1 = featureMap(category1{i});
        for j = 1 : length(category2)
            feature2 = featureMap(category2{j});
            distanceList = [distanceList getDistance(feature1, feature2)];
        end
    end
    avgDistance = sum(distanceList) / length(distanceList);
end

function distance = getDistance(point1, point2)
    X = [point1; point2];
    distance = pdist(X,'euclidean');
end

% extract all imgIDs
function imgIDList = extractImgID(categoryList, taxonomyMap, baseFolder)
    imgIDList = cell(1, length(categoryList));
    for iCategory = 1 : length(categoryList)
		% retrieve all IDs (filenames) of this category
		nodeFolderList = getNodeFolderList(categoryList{iCategory}, baseFolder, taxonomyMap);
		imgIDList{iCategory} = cellfun(@(x) strrep(x, strcat(baseFolder, '/'), ''),...
			getFileNameList(nodeFolderList), 'UniformOutput', false);
	end
end