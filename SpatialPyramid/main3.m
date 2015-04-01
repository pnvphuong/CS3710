% add path
addpath(genpath('classifier')); % add classifier
addpath(genpath('taxonomy')); % add taxonomy
% image_dir = 'D:/datasets/256_ObjectCategories';
image_dir = 'E:\nineil\phd\general_datasets\256_ObjectCategories';
data_dir = 'data';

load('caltechTaxonomy.mat');
tax = caltechTaxonomyMap;

%step 1: create top classifier [assuming 2 classes for now: air and land]
childsRoot = tax('air'); % animal, air
c1 = childsRoot{1}; % air, ibis
c2 = childsRoot{2}; % land, hawksbill

folders_c1 = getNodeFolderList(c1, image_dir, tax);
files_c1 = getFileNameList(folders_c1);
files_c1 = cellfun(@(x) strrep(x, image_dir, ''), files_c1, ...
            'UniformOutput', false);
classes_c1 = repmat({'1'},1,length(files_c1));
classes_c1n = repmat(1,1,length(files_c1));

folders_c2 = getNodeFolderList(c2, image_dir, tax);
files_c2 = getFileNameList(folders_c2);
files_c2 = cellfun(@(x) strrep(x, image_dir, ''), files_c2, ...
            'UniformOutput', false);
classes_c2 = repmat({'-1'},1,length(files_c2));
classes_c2n = repmat(-1,1,length(files_c2));

classes_tot = [classes_c1 classes_c2];
dataClass = [classes_c1n classes_c2n];
filenames = [files_c1; files_c2];

%# split into train/test datasets: 30% test and 70% train
[trainIndex, testIndex] = crossvalind('holdout',classes_tot,0.3, ...
                            'Classes',{'-1','1'});

% IMP: crossvalind requires classes as strings, however libsvm require
% number

trainData = filenames(trainIndex);
testData = filenames(testIndex);
trainClass = dataClass(trainIndex)';
testClass = dataClass(testIndex)';
numTrain = size(trainData,1);
numTest = size(testData,1);

%# Extract features
pyramid_train = BuildPyramid(trainData,image_dir,data_dir);
pyramid_test = BuildPyramid(testData,image_dir,data_dir);

% test all data generate the same feature vectors as train and test?
allData = [trainData; testData];
pyramid_all = BuildPyramid(allData,image_dir,data_dir);

% compares
a1 = pyramid_all(end-10:end, end-10:end);
a2 = pyramid_test(end-10:end, end-10:end);
fprintf('equal a1 with a2: %d\n', isequal(a1, a2));

a3 = pyramid_train(1:10, 1:10);
a4 = pyramid_all(1:10, 1:10);
fprintf('equal a3 with a4: %d\n', isequal(a3, a4));

% %# compute kernel matrices between every pairs of (train,train) and
% %# (test,train) instances and include sample serial number as first column
% k1 = hist_isect(pyramid_train, pyramid_train);
% k2 = hist_isect(pyramid_test, pyramid_train);
% 
% K =  [ (1:numTrain)' , k1 ];
% KK = [ (1:numTest)'  , k2 ];
% 
% %# train and test
% model = svmtrain(trainClass, K, '-t 4');
% [predClass, acc, decVals] = svmpredict(testClass, KK, model);
% 
% %# confusion matrix
% C = confusionmat(testClass,predClass);