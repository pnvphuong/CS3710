function decVals = predictBinaryClassifier(KK, classVector, classifier)
	[predClass, acc, decVals] = svmpredict(classVector, KK, classifier, '-b 1 -q');	
end