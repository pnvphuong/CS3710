function classifierList = buildLeafNodeClassifierList(trainIDList, featureMap)
	classifierList = cell(1, length(trainIDList));

	for iCategory = 1 : length(trainIDList)
		% extract positive feature
		posIDList = cellstr(trainIDList{iCategory});
		posFeatureList = getFeatureFromID(featureMap, posIDList);
		% extract negative feature
		negIDList = cellstr(getNegIDList(trainIDList, iCategory));
		negFeatureList = getFeatureFromID(featureMap, negIDList);
		% build classifier
		classifierList{iCategory} = buildBinaryClassifier(posFeatureList, negFeatureList);
	end
end

function negIDList = getNegIDList(trainIDList, iCategory)
	negIDList = [];
	for i = 1 : length(trainIDList)
		if i == iCategory
			continue;
        end
        negIDList = [negIDList; trainIDList{i}];
    end
end

function featureList = getFeatureFromID(featureMap, idList)
	featureList = [];
	for i = 1 : length(idList)
		featureList = [featureList; featureMap(idList{i})];
	end
end