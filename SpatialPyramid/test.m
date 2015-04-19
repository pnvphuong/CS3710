
% matrix = [0 1 4 2; 1 0 2 3; 4 2 0 1; 2 3 1 0];
% categoryNameHierarchy = hierarchyFromMatrix(matrix, {'A', 'B', 'C', 'D'});
% save('../data/GriffinHierarchy.mat', 'categoryNameHierarchy');
% buildClassifierHierarchy(categoryNameHierarchy);

k = {'owl-ostrich-duck-goose', 'owl-ostrich', 'duck-goose'};
v = {{'owl-ostrich', 'duck-goose'}, {'owl', 'ostrich'}, {'duck', 'goose'}};
nameHierarchy = containers.Map(k,v);
evaluateHierarchy(nameHierarchy);
% hierarchy2String(nameHierarchy);


