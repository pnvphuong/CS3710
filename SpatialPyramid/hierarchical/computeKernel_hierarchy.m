% map_kernels = computeKernel_hierarchy( refined_IDList, featureMap)
function map_kernels = computeKernel_hierarchy( map_trainIDList_testIDList , featureMap)
    values = {};
    ks = keys(map_trainIDList_testIDList);
    for i=1:length(map_trainIDList_testIDList)
        k = ks{i};
        val = map_trainIDList_testIDList(k);
        trainIDList = val{1};
        testIDList = val{2};
        [K, KK, trainID, testID] = computeKernel(trainIDList, testIDList, featureMap);
        val = {{K, KK, trainID, testID}};
        values = [values val];
    end
    
    % create output map
    M = containers.Map(ks, values);
    map_kernels = M;
end

