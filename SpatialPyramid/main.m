%# read dataset
image_dir = 'images'; 
data_dir = 'data';
addpath(genpath('classifier')); % add classifier

% for other parameters, see BuildPyramid
fnames = dir(fullfile(image_dir, '*.jpg'));
num_files = size(fnames,1);
filenames = cell(num_files,1);

for f = 1:num_files
	filenames{f} = fnames(f).name;
end

%# split into train/test datasets
dataClass = [1, -1, 1, -1, 1];
trainIndex = 1:3;
testIndex = 4:5;

trainData = filenames(trainIndex);
testData = filenames(testIndex);
trainClass = dataClass(trainIndex)';
testClass = dataClass(testIndex)';
numTrain = size(trainData,1);
numTest = size(testData,1);

%# Extract features
pyramid_train = BuildPyramid(trainData,image_dir,data_dir);
pyramid_test = BuildPyramid(testData,image_dir,data_dir);

%# compute kernel matrices between every pairs of (train,train) and
%# (test,train) instances and include sample serial number as first column
k1 = hist_isect(pyramid_train, pyramid_train);
k2 = hist_isect(pyramid_test, pyramid_train);

K =  [ (1:numTrain)' , k1 ];
KK = [ (1:numTest)'  , k2 ];

%# train and test
model = svmtrain(trainClass, K, '-t 4');
[predClass, acc, decVals] = svmpredict(testClass, KK, model);

%# confusion matrix
C = confusionmat(testClass,predClass);
