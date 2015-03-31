function [K, KK, trainID, testID] = computeKernel(trainIDList, testIDList, featureMap)
	[trainFeatureTable, trainID] = getFeatureList(trainIDList, featureMap);
	[testFeatureTable, testID] = getFeatureList(testIDList, featureMap);

	k = hist_isect(trainFeatureTable, trainFeatureTable);
	K = [ (1:size(trainFeatureTable,1))' , k ];
	kk = hist_isect(testFeatureTable, trainFeatureTable);
	KK = [ (1:size(testFeatureTable,1))' , kk ];
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