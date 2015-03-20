% website: http://stackoverflow.com/questions/7715138/using-precomputed-kernels-with-libsvm

%# read dataset
[dataClass, data] = libsvmread('./heart_scale');

%# split into train/test datasets
trainIndex = 1:150;
testIndex = 151:270;

trainData = data(trainIndex,:);
testData = data(testIndex,:);
trainClass = dataClass(trainIndex,:);
testClass = dataClass(testIndex,:);
numTrain = size(trainData,1);
numTest = size(testData,1);

%# radial basis function: exp(-gamma*|u-v|^2)
sigma = 2e-3;
rbfKernel = @(X,Y) exp(-sigma .* pdist2(X,Y,'euclidean').^2);

%# compute kernel matrices between every pairs of (train,train) and
%# (test,train) instances and include sample serial number as first column
K =  [ (1:numTrain)' , rbfKernel(trainData,trainData) ];
KK = [ (1:numTest)'  , rbfKernel(testData,trainData)  ];

%# train and test
model = svmtrain(trainClass, K, '-t 4');
[predClass, acc, decVals] = svmpredict(testClass, KK, model);

%# confusion matrix
C = confusionmat(testClass,predClass)