% r = map_IDList('animal');
% getGroundTruth( r{2} , categoryList)

% TODO: have problems when two names are similar, e.g. horse and horse-crab
% in test_instances
function vg = getGroundTruth( test_instances , leaves)
vg = {};
for i = 1: length(test_instances) % number of classes
    class_instances = test_instances{i};
    for j = 1: length(class_instances)
        instance = class_instances{j};
        for k = 1: length(leaves)
            leaf = leaves{k};
            if isempty(strfind(instance, leaf)) == false % found
                vg = [vg leaf];
            end
        end
    end
end

end

