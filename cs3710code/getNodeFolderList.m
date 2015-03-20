function nodeFolderList = getNodeFolderList(nodeName, baseFolder, taxonomyMap)
    nodeFolderList = {};
    if isKey(taxonomyMap, nodeName)
        childrenNode = taxonomyMap(nodeName);
        if iscellstr(childrenNode) %recursive call
            for i = 1 : length(childrenNode)
                nodeFolderList = [nodeFolderList; ...
                    getNodeFolderList(childrenNode{i}, baseFolder, taxonomyMap)];
            end
        else % return the folder name
            nodeFolderList = {strcat(baseFolder, '/', childrenNode)};
        end
    end
end