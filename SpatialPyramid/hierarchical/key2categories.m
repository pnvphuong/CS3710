function v = key2categories(k, taxonomyMap)
    % base case
    if isLeafKey(k, taxonomyMap)
        v = {k};
    else
        childs = taxonomyMap(k);
        vs = {};
        for i = 1:length(childs)
            child = childs{i};
            v2 = key2categories(child, taxonomyMap);
            vs = [vs v2];
        end
        v = vs;
    end
end