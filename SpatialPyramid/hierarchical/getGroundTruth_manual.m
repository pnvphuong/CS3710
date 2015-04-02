function vg = getGroundTruth_manual( test_instances )
vg = {};
for i = 1: length(test_instances) % number of classes
    class_instances = test_instances{i};
    for j = 1: length(class_instances)
        instance = class_instances{j};
        instance = strrep(instance, '.jpg', '');
        instance = strrep(instance, '.', '');
        instance = strrep(instance, '/', '');
        instance = strrep(instance, '_', '');
        instance = regexprep(instance,'-\d','');
        instance = regexprep(instance,'(\d*)','');
        vg = [vg instance];
    end
end
end

