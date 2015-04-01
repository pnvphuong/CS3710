function map_IDList = extractTrainTestList_hierarchy(rootName, taxonomyMap, trainTestRatio, baseFolder, str)
    if isLeafKey(rootName, taxonomyMap)
        % base case
        % fprintf('leaf: %s\n', rootName)

        % retrieve all IDs (filenames) of this group of categories
        nodeFolderList = getNodeFolderList(rootName, baseFolder, taxonomyMap);
        categoryIDList = cellfun(@(x) strrep(x, strcat(baseFolder, '/'), ''), ...
                                getFileNameList(nodeFolderList ), 'UniformOutput', false);

        % randomize and split train, test set
        rndIdxList = randperm(length(categoryIDList));% TODO: split is stratified?
        %  the first trainTestRatio is test set
        testNum = floor(length(categoryIDList) * trainTestRatio);
        testIDList = categoryIDList(rndIdxList(1 : testNum));
        trainIDList = categoryIDList(rndIdxList(testNum + 1 : end));
        
        
        keySet =   {rootName};
        valueSet = { {trainIDList, testIDList} };
        M = containers.Map(keySet,valueSet);
        map_IDList = M;
        return
    else
        % Recursive Step
        % fprintf('%s root: %s\n', str, rootName)
        childs_categ = taxonomyMap(rootName);
        TS = [];
        trainIDList = {};
        testIDList = {};
        for i =1: length(childs_categ)
            % fprintf(' %s iteration: %d\n', str, i)
            child = childs_categ{i};
            % fprintf(' %s child: %s\n', str, child)
            MR = extractTrainTestList_hierarchy(child, taxonomyMap, trainTestRatio, baseFolder, [str '   ']);
            child_train_test = MR(child);
            trainIDList = [trainIDList child_train_test(1)];
            testIDList = [testIDList  child_train_test(2)];
            TS = [TS; MR];
        end
        TS(rootName) = { trainIDList, testIDList };
        map_IDList = TS;
        return
    end
end