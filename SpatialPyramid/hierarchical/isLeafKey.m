function b = isLeafKey(k, taxonomyMap)
    b = false;
    x = taxonomyMap(k); % get value
    b = ~isKey(taxonomyMap, x);
end