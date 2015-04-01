function evaluationTable = predictLeafNodeClassifierList(KK, testID, testIDList, classifierList)
	% prediction probability on each class
	predProb = zeros(length(testID), length(classifierList));
	groundTruth = [];
	% predict on each classifier
	classVector = ones(length(testID),1);
	for iCategory = 1 : length(classifierList)
		disp(sprintf('\t\tclassifier %d',iCategory))
		% get prediction probability
		decVals = predictBinaryClassifier(KK, classVector, classifierList{iCategory});
		% merge into the prediction matrix
		predProb(:,iCategory) = decVals(:,find(classifierList{iCategory}.Label == 1));
		% create ground truth for this category
		categoryGroundTruth = zeros((length(testIDList{iCategory})), length(classifierList));
		categoryGroundTruth(:, iCategory) = ones(size(categoryGroundTruth,1),1);
		groundTruth = [groundTruth; categoryGroundTruth];
	end
	% find the maximum prediction probability for each test image
	mx = max( predProb, [], 2 ); % max probability in each row
	% prediction class for each test image with tie breaker
	% only keep the first maximum probability
	predClass = tieBreaker(bsxfun(@eq, predProb,mx));

	evaluationTable = table(testID, predClass, groundTruth, 'VariableNames', {'file_name' 'prediction' 'goldStandard'});
end

function tieBreakVector = tieBreaker(inputVector)
	tieBreakVector = inputVector;
	for i = 1 : size(tieBreakVector,1)
		rowSum = sum(tieBreakVector(i,:));
		if  rowSum > 1
			for j = 1 : length(tieBreakVector(i,:))
				if tieBreakVector(i,length(tieBreakVector(i,:)) - j + 1) ~= 0
					tieBreakVector(i,length(tieBreakVector(i,:)) - j + 1) = 0;
					rowSum = rowSum - 1
					if rowSum == 1
						break;
					end
				end
			end
		end
	end
end