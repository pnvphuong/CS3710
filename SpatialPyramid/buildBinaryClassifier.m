function classifier = buildBinaryClassifier(posFeatureTable, negFeatureTable)
	% create class data, i.e. 1, -1
	posClassStr = repmat({'1'},1,size(posFeatureTable,1));
	posClassNum = repmat(1,1,size(posFeatureTable,1));    
	negClassStr = repmat({'-1'},1,size(negFeatureTable,1));
	negClassNum = repmat(-1,1,size(negFeatureTable,1));
	% create total data
	classes_tot = [posClassStr negClassStr];
	dataClass = [posClassNum negClassNum];
	featureTable = [posFeatureTable; negFeatureTable];

	% compute kernels
    k = hist_isect(featureTable, featureTable);
    K =  [ (1:size(featureTable,1))' , k ];
    % train model
    classifier = svmtrain(trainClass, K, '-t 4 -b 1');
end