% pred = predictInstanceClassifierHierarchy('animal', map_kernels, map_learned_models , '100.hawksbill-101/100_0030.jpg', featureMap, tax2)
function pred = predictInstanceClassifierHierarchy( root_name, map_kernels, map_learned_models , new_instance, featureMap, tax_names)

while isLeafKey(root_name, tax_names) == false
    % root
    classifierList = map_learned_models(root_name);
    val_kernel = map_kernels(root_name);
    trainFeatureTable = val_kernel{5};

    % compute kernel of new instance
    feat = featureMap(new_instance);
    testFeatureTable = feat;
    kk = hist_isect(testFeatureTable, trainFeatureTable);
    KK = [ (1:size(testFeatureTable,1))' , kk ];

    % prediction
    vp = [];
    for iCategory = 1 : length(classifierList)        
        decVals = predictBinaryClassifier(KK, [-1], classifierList{iCategory});
        pred = decVals(find(classifierList{iCategory}.Label == 1)); % get positive class
        vp = [vp pred];
    end

    % select which branch
    [~, pos]=max(vp);
    childs = tax_names(root_name);
    new_root = childs{pos};
    root_name = new_root;
end
pred = root_name;
end

