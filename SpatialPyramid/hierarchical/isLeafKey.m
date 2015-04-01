function b = isLeafKey(k, taxonomyMap)
    b = false;
    x = taxonomyMap(k);
    if iscell(x)==0 % one element
        b = ~isKey(taxonomyMap, x);
    end
end