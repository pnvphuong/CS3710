function featureTable = getFeatureOfCategory(nodeNameList, taxonomyMap,...
    dsFeatureTable, baseFolder)
    if isa(dsFeatureTable, 'table')
        featureTable = getFeatureOfCategoryTable(nodeNameList, taxonomyMap,...
                            dsFeatureTable, baseFolder);
    else
        featureTable = getFeatureOfCategoryMap(nodeNameList, taxonomyMap,...
                            dsFeatureTable, baseFolder);
    end
end

function featureTable = getFeatureOfCategoryTable(nodeNameList, taxonomyMap,...
    dsFeatureTable, baseFolder)
    featureTable = [];
    for i = 1 : length(nodeNameList)
        nodeFolderList = getNodeFolderList(nodeNameList{i}, baseFolder, taxonomyMap);
        fnList = cellfun(@(x) strrep(x, strcat(baseFolder, '/'), ''),...
            getFileNameList(nodeFolderList), 'UniformOutput', false);         
        for j = 1 : length(fnList)
            featureTable = [featureTable; dsFeatureTable{...
                getFeatureIdxFromFn(fnList{j}, dsFeatureTable),2}];
        end
    end
end

function featureIdx = getFeatureIdxFromFnTable(fn, dsFeatureTable)    
    for i = 1 : size(dsFeatureTable,1)
        if strcmp(fn, dsFeatureTable{i,1}) == 1
            featureIdx = i;
            break;
        end
    end
end

function featureTable = getFeatureOfCategoryMap(nodeNameList, taxonomyMap,...
    dsFeatureTable, baseFolder)
    featureTable = [];
    for i = 1 : length(nodeNameList)
        nodeFolderList = getNodeFolderList(nodeNameList{i}, baseFolder, taxonomyMap);
        fnList = cellfun(@(x) strrep(x, strcat(baseFolder, '/'), ''),...
            getFileNameList(nodeFolderList), 'UniformOutput', false);         
        for j = 1 : length(fnList)
            featureTable = [featureTable; dsFeatureTable(fnList{j})];
        end
    end
end