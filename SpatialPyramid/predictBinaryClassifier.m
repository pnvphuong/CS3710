function predictionTable = predictBinaryClassifier(K, testClass, classifier)
	[predClass, acc, decVals] = svmpredict(testClass, K, classifier);
	decVals
end