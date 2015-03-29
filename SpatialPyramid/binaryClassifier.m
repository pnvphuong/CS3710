function confusionMatrix = binaryClassifier(posFeatureTable, negFeatureTable,...
        trainTestRatio)
    % create class data, i.e. 1, -1
    posClassStr = repmat({'1'},1,size(posFeatureTable,1));
    posClassNum = repmat(1,1,size(posFeatureTable,1));    
    negClassStr = repmat({'1'},1,size(negFeatureTable,1));
    negClassNum = repmat(-1,1,size(negFeatureTable,1));
    % create total data
    classes_tot = [posClassStr negClassStr];
    dataClass = [posClassNum negClassNum];
    featureTable = [posFeatureTable; negFeatureTable];
    % get train, test idx
    [trainIdx, testIdx] = crossvalind('holdout',classes_tot,trainTestRatio, ...
               'Classes',{'-1','1'});
    trainClass = dataClass(trainIdx)';
    testClass = dataClass(testIdx)';
    posCount = testClass == 1;
    sum(posCount)
    length(posCount) - sum(posCount)
    numTrain = size(trainClass,1);
    numTest = size(testClass,1);
    pyramid_train = featureTable(trainIdx, :);    
    pyramid_test = featureTable(testIdx, :);
    
    % compute kernels
    k1 = hist_isect(pyramid_train, pyramid_train);
    k2 = hist_isect(pyramid_test, pyramid_train);
    K =  [ (1:numTrain)' , k1 ];
    KK = [ (1:numTest)'  , k2 ];
    
    % train and test
    model = svmtrain(trainClass, K, '-t 4');
    [predClass, acc, decVals] = svmpredict(testClass, KK, model);
    acc
    
    % confusion matrix
    confusionMatrix = confusionmat(testClass,predClass)
end