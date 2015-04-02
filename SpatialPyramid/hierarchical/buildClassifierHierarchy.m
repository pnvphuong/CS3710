% map_learned_models = buildClassifierHierarchy( map_kernels, refined_IDList)
function map_learned_models = buildClassifierHierarchy( map_kernels, map_trainIDList_testIDList)
    values = {};
    ks = keys(map_kernels);
    for i=1:length(map_kernels)
        k = ks{i};
        val_kernel = map_kernels(k);
        val_train_test = map_trainIDList_testIDList(k);
        
        K = val_kernel{1};
        trainIDList = val_train_test{1};
        
        classifierList = buildLeafNodeClassifierList(K, trainIDList);
        % classifierList
        values = [values {classifierList}];
    end
    
    % create output map
    M = containers.Map(ks, values);
    map_learned_models = M;
end

