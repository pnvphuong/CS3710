% load('../taxonomy/caltechTaxonomy.mat');
% mn = get_map_names(caltechTaxonomyMap)
function mn = get_map_names(tax)
% other functions
replace_digits = @(x) regexprep(x, '(-?\d+)','');
replace_point = @(x) strrep(x, '.', '');

% process
vals = values(tax);
ix = cellfun(@ischar, vals);
vals = vals(ix);
% ks = vals;
ks = cellfun(replace_digits, vals, 'UniformOutput', false);
ks = cellfun(replace_point, ks, 'UniformOutput', false);
map_names = containers.Map(ks, vals);
mn = map_names;