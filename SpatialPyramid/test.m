
trainIDList = cell(1, 2);
testIDList = cell(1, 2);
trainTestRatio = 0.3;

rng(1);
for iCategory = 1 : 2
	% retrieve all IDs (filenames) of this category
	categoryIDList = [1 2 3 4 5 6 7 8 9] .* iCategory;

	% randomize and split train, test set
	rndIdxList = randperm(length(categoryIDList));
	%  the first trainTestRatio is test set
	testNum = round(length(categoryIDList) * trainTestRatio);
	testIDList{iCategory} = categoryIDList(rndIdxList(1 : testNum));
	trainIDList{iCategory} = categoryIDList(rndIdxList(testNum + 1 : end));		
end

for i = 1 : length(trainIDList)
	testIDList{i}
end