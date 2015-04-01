% map_predictions = predictClassifierHierarchy( map_kernels, refined_IDList, map_learned_models)
function map_predictions = predictClassifierHierarchy( map_kernels, map_trainIDList_testIDList, map_learned_models)
    values = {};
    ks = keys(map_kernels);
    for i=1:length(map_kernels)
        k = ks{i};
        val_kernel = map_kernels(k);
        val_train_test = map_trainIDList_testIDList(k);
        classifierList = map_learned_models(k);
        
        KK = val_kernel{2};
        testID = val_kernel{4};
        testIDList = val_train_test{2};
        
        T = predictLeafNodeClassifierList(KK, testID, testIDList, classifierList);
        values = [values {T}];
    end
    
    % create output map
    M = containers.Map(ks, values);
    map_predictions = M;
end

