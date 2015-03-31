function classifier = buildBinaryClassifier(K, classVector)	
    classifier = svmtrain(classVector, K, '-t 4 -b 1 -q');
end