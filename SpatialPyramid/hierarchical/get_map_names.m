% mn = get_map_names()
function mn = get_map_names()
% other functions
replace_digits = @(x) regexprep(x, '(-?\d+)','');
replace_point = @(x) strrep(x, '.', '');

% process
load('../taxonomy/caltechTaxonomy.mat');
tax = caltechTaxonomyMap;
vals = values(tax);
ix = cellfun(@ischar, vals);
vals = vals(ix);
ks = vals;
vals = cellfun(replace_digits, vals, 'UniformOutput', false);
vals = cellfun(replace_point, vals, 'UniformOutput', false);
map_names = containers.Map(ks, vals);
mn = map_names;