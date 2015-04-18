% r = map_IDList('animal');
% predictions = predictClassifierHierarchy('animal', map_kernels, r{2}, map_learned_models, featureMap, tax2)
function predictions = predictClassifierHierarchy(root_name, map_kernels, test_instances, map_learned_models, featureMap, tax_names)

vp = {};
for i = 1: length(test_instances) % number of classes
    class_instances = test_instances{i};
    for j = 1: length(class_instances)
        instance = class_instances{j};
        pred = predictInstanceClassifierHierarchy(root_name, map_kernels, map_learned_models , instance, featureMap, tax_names);
        vp = [vp pred];
    end
end
predictions = vp;


%     values = {};
%     ks = keys(map_kernels);
%     for i=1:length(map_kernels)
%         k = ks{i};
%         val_kernel = map_kernels(k);
%         val_train_test = map_trainIDList_testIDList(k);
%         classifierList = map_learned_models(k);
%         
%         KK = val_kernel{2};
%         testID = val_kernel{4};
%         testIDList = val_train_test{2};
%         
%         T = predictLeafNodeClassifierList(KK, testID, testIDList, classifierList);
%         T
%         values = [values {T}];
%     end
%     
%     % create output map
%     M = containers.Map(ks, values);
%     map_predictions = M;
end

