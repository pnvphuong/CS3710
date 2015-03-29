function featureTable = getFeatureOfCategory(nodeNameList, taxonomyMap,...
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

function featureIdx = getFeatureIdxFromFn(fn, dsFeatureTable)    
    for i = 1 : size(dsFeatureTable,1)
        if strcmp(fn, dsFeatureTable.file_name(i)) == 1
            featureIdx = i;
            break;
        end
    end
end