function [trainIDList, testIDList] = extractTrainTestList_hierarchy(categoryList,...
							taxonomyMap, trainTestRatio, baseFolder)
                        
    trainIDList = cell(1, length(categoryList));
	testIDList = cell(1, length(categoryList));
    
    v = key2categories(k, taxonomyMap)

	for iCategory = 1 : length(categoryList)
		% retrieve all IDs (filenames) of this category
		nodeFolderList = getNodeFolderList(categoryList{iCategory}, baseFolder, taxonomyMap);
		categoryIDList = cellfun(@(x) strrep(x, strcat(baseFolder, '/'), ''),...
			getFileNameList(nodeFolderList), 'UniformOutput', false);

		% randomize and split train, test set
		rndIdxList = randperm(length(categoryIDList));
		%  the first trainTestRatio is test set
		testNum = floor(length(categoryIDList) * trainTestRatio);
		testIDList{iCategory} = categoryIDList(rndIdxList(1 : testNum));
		trainIDList{iCategory} = categoryIDList(rndIdxList(testNum + 1 : end));
	end
end