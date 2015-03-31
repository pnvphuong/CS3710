% function tax2leaves(tax, out_file)
tax = load('caltechTaxonomy.mat');
tax = tax.caltechTaxonomyMap;
out_file = 'leaves.txt';

k = keys(tax);
vl = {};
for ki = k
    if iscell(tax(ki{1})) == false
        vl = [vl ki{1}];
    end
end

% Write file of leaves
T = table(vl','VariableNames',{'Nouns'});
writetable(T, 'leaves.txt');


