
% matrix = [0 1 4 2; 1 0 2 3; 4 2 0 1; 2 3 1 0];
% categoryNameHierarchy = hierarchyFromMatrix(matrix, {'A', 'B', 'C', 'D'});
% save('../data/GriffinHierarchy.mat', 'categoryNameHierarchy');
% buildClassifierHierarchy(categoryNameHierarchy);

% k = {'owl-ostrich-duck-goose', 'owl-ostrich', 'duck-goose'};
% v = {{'owl-ostrich', 'duck-goose'}, {'owl', 'ostrich'}, {'duck', 'goose'}};
% nameHierarchy = containers.Map(k,v);
% evaluateHierarchy(nameHierarchy);
% hierarchy2String(nameHierarchy);

categoryList = {'ibis', 'hawksbill', 'hummingbird', 'cormorant', 'duck', ...
        'goose', 'ostrich', 'owl', 'penguin', 'swan', ...
        'bat', 'bear', 'camel', 'chimp', 'dog', 'elephant', ...
        'elk', 'frog', 'giraffe', 'goat', 'gorilla', ...
        'horse', 'iguana', 'kangaroo', 'llama', ...
        'leopards', 'porcupine', 'raccoon', 'skunk', ...
        'snake', 'snail', 'zebra', 'greyhound', 'toad', ...
        'horseshoe-crab', 'crab', 'conch', 'dolphin', ...
        'goldfish', 'killer-whale', 'mussels', 'octopus', 'starfish'};
%load('../data/euclideanConfusionMatrix.mat');
euclideanCategoryNameHierarchy = hierarchyFromMatrix(euclideanConfusionMatrix, categoryList);
save('../data/euclideanNameHierarchy.mat', 'euclideanCategoryNameHierarchy');
euclideanString = hierarchy2String(euclideanCategoryNameHierarchy);
% save hierarchy string
fileID = fopen('../data/euclideanHierarchyString.txt','w');
fprintf(fileID,'%s',euclideanString);
fclose(fileID);


