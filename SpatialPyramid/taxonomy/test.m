
clear
% baseFolder = '../256_ObjectCategories'; % this script is under a sibbling
% folder with 256_ObjectCategories
% baseFolder = '.'; % this script is under 256_ObjectCategories

baseFolder = 'D:/datasets/256_ObjectCategories';

% create caltechTaxonomy, used to retrieve all filename of a specific
% category
% createCaltechTaxonomy;
load('caltechTaxonomy.mat');

folderList = getNodeFolderList('dog', baseFolder, caltechTaxonomyMap);
fnList = getFileNameList(folderList) % list of all images filename
% if we change the baseFolder value to the folder containing all extracted
% features (using the same structure as 256_ObjectCategories, we can also
% extract all feature vectors of a specific category (for training or
% testing)