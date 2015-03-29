function confusionMatrixList = oneVSAll(categoryList, taxonomyMap,...
        dsFeatureTable, baseFolder, trainTestRatio)    
    confusionMatrixList = cell(length(categoryList));
    for i = 1 : length(categoryList)
        sprintf('%s vs others', categoryList{i});
        % get pos and neg category names
        posCategoryList = cell(1);
        posCategoryList{1} = categoryList{i};        
        negCategoryList = getOtherCategoryList(categoryList, categoryList{i});        
        % extract feature vectors
        posFeatureList = getFeatureOfCategory(posCategoryList, taxonomyMap,...
                dsFeatureTable, baseFolder);        
        negFeatureList = getFeatureOfCategory(negCategoryList, taxonomyMap,...
                dsFeatureTable, baseFolder);        
        % evaluate model
        confusionMatrixList{i} = binaryClassifier(posFeatureList, negFeatureList,...
            trainTestRatio);
    end
end

function otherCategoryList = getOtherCategoryList(categoryList, category)
    otherCategoryList = cell(length(categoryList) - 1);
    count = 1;
    for i = 1 : length(categoryList)
        if strcmp(category, categoryList{i}) == 1
            continue;
        end
        otherCategoryList{count} = categoryList{i};
        count = count + 1;
    end
end