function classifier = buildBinaryClassifier(posFeatureTable, negFeatureTable)
	% create class data, i.e. 1, -1
	posClassNum = repmat(1,1,size(posFeatureTable,1));    
	negClassNum = repmat(-1,1,size(negFeatureTable,1));
	% create total data
	dataClass = [posClassNum negClassNum]';
	featureTable = [posFeatureTable; negFeatureTable];
	% compute kernels
    k = hist_isect(featureTable, featureTable);
    K =  [ (1:size(featureTable,1))' , k ];
    % train model
    classifier = svmtrain(dataClass, K, '-t 4 -b 1');
end