function classifierList = buildLeafNodeClassifierList(K, trainIDList)
	classifierList = cell(1, length(trainIDList));

	for iCategory = 1 : length(trainIDList)
		% build class value list
		classValue = getClassValue(trainIDList, iCategory);
		% build classifier
		classifierList{iCategory} = buildBinaryClassifier(K, classValue);
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