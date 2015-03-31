function predictionTable = predictBinaryClassifier(trainPosFeature, trainNegFeature,...
							testPosFeature, testNegFeature, classifier)
	testClass = [testPosFeature testPosFeature];
	featureTrainTable = [trainPosFeature; trainNegFeature];
	featureTestTable = [testPosFeature; testNegFeature];
	k = hist_isect(featureTestTable, featureTrainTable);
	K = [ (1:size(featureTestTable,1))'  , k ];
	[predClass, acc, decVals] = svmpredict(testClass, K, classifier);
	
end