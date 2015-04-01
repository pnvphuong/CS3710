function refined_IDList = refineMap_IDList( map_IDList, tax_map )
    % remove all leaf nodes
    ks = keys(tax_map);
    for i=1:length(tax_map)
        k = ks{i};
        if isLeafKey(k, tax_map)
            % fprintf('key: %s\n', k)
            remove(map_IDList, k);
        end
    end    
        
    % merge node appropriately
    ks = keys(map_IDList);
    for i=1:length(map_IDList)
        k = ks{i};
        val = map_IDList(k);
        trainNodes = val{1};
        testNodes = val{2};
        
        % train - nodes
        new_train = cell(1, length(trainNodes));
        for j=1:length(trainNodes)
            node = trainNodes{j};
            new_train{j} = merge_nodes(node);
        end
        
        % test - nodes
        new_test = cell(1, length(testNodes));
        for j=1:length(testNodes)
            node = testNodes{j};
            new_test{j} = merge_nodes(node);
        end
        map_IDList(k) = {new_train, new_test};        
    end
     refined_IDList = map_IDList;
end


