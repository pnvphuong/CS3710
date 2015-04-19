function treeString = hierarchy2String(nameHierarchy)
    % get root, the longest key
    nodeNameList = keys(nameHierarchy);
    nodeNameLengthList = cellfun(@length, nodeNameList);
    rootNode = nodeNameList{find(nodeNameLengthList == max(nodeNameLengthList))};
    treeString = appendTree(rootNode,nameHierarchy,0, '');
end

function string = appendTree(nodeName,nameHierarchy,iLevel, inString)
    string = inString;
    for i = 1 : iLevel
        string = sprintf('%s\t',string);
    end
    string = sprintf('%s%s\n',string,nodeName);
    % is non-terminal?
    if isKey(nameHierarchy,nodeName)
        subNodeList = nameHierarchy(nodeName);
        for i = 1 : length(subNodeList)
            subNodeName = subNodeList{i};
            string = appendTree(subNodeName,nameHierarchy,iLevel+1,string);
        end
    end
end