function predictionTable = predictLeafNodeClassifierList(trainIDList, testIDList, classifierList,...
	 						featureMap)

	testFeatureList = getTestFeatureList(testIDList, featureMap);

	for iCategory = 1 : length(testIDList)
		trainFeatureTable = getFeatureFromID(featureMap,...
							cellstr(trainIDList{iCategory}));
		trainNegFeature = getFeatureFromID(featureMap,...
							cellstr(getNegIDList(trainIDList,...
							iCategory)));
		predictBinaryClassifier(trainPosFeature, trainNegFeature,...
							testPosFeature, testNegFeature, classifier)
	end
end

function testFeatureList = getTestFeatureList(testIDList, featureMap)
	idList = [];
	for i = 1 : length(testIDList)
		idList = [idList; testIDList{i}]
	end
	idList = cellstr(idList);

	testFeatureList = getFeatureFromID(featureMap, idList);
end