addpath(genpath('classifier')); % add classifier
addpath(genpath('taxonomy')); % add taxonomy
addpath(genpath('../data'));

load('caltechTaxonomy.mat');
load('feat_data.mat');
baseFolder = '../data/256_ObjectCategories';
trainTestRatio = 0.3;

categoryList = {'goat', 'bat'};
confusionMatrixList = oneVSAll(categoryList, caltechTaxonomyMap,...
        TF, baseFolder, trainTestRatio);
for i = 1 : length(confusionMatrixList)
    confusionMatrixList{i}
end

% a = [1 2 3; 4 5 6;7 8 9]
% c = [1 0 1];
% b = a(1, :)