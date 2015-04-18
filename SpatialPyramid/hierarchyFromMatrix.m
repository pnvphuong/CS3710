function categoryNameHierarchy = hierarchyFromMatrix(matrix, categoryNameList)
    categoryNameParent = {};
    categoryNameChildren = {};
    while (size(matrix,1) > 1)
        % find maximum cell (assume diagnal values are all 0)
        [mRowList, mColList] = find(matrix == max(matrix(:)));
        for i = 1 : length(mRowList)
            if mRowList(i) ~= mColList(i)
                mRow = mRowList(i);
                mCol = mColList(i);
                break;
            end
        end
        % rebuild the string and create map
        newCategoryNameList = cell(1, length(categoryNameList) - 1);
        newCategoryNameList{1} = strcat(categoryNameList{mRow},'-',...
                                categoryNameList{mCol});
        categoryNameParent = [categoryNameParent newCategoryNameList{1}];
        categoryNameChildren = [categoryNameChildren {{categoryNameList{mRow} categoryNameList{mCol}}}];
        iName = 2;
        k = cell(1, length(newCategoryNameList));
        v = zeros(1, length(k));
        k{1} = newCategoryNameList{1};
        v(1) = 0;
        for i = 1 : length(categoryNameList)
            if i == mCol || i == mRow
                continue;
            end
            newCategoryNameList{iName} = categoryNameList{i};
            k{iName} = categoryNameList{i};
            v(iName) = i;
            iName = iName + 1;
        end
        % map
        categoryNameMap = containers.Map(k,v);
        
        % build the new matrix
        newMatrix = zeros(size(matrix,1) - 1, size(matrix,1) - 1);        
        r1 = mRow;
        r2 = mCol;
        for i = 2 : length(newCategoryNameList)
            curCol = categoryNameMap(newCategoryNameList{i});
            % first row is avg C_avg_i            
            newMatrix(1,i) = (matrix(r1,curCol) + matrix(r2,curCol))/2;
            % first col is avg C_i_avg
            newMatrix(i,1) = (matrix(curCol,r1) + matrix(curCol,r2))/2;
        end
        
        % other cells do not change because not related to merged
        % categories
        for iRow = 2 : length(newCategoryNameList)
            for iCol = 2 : length(newCategoryNameList)
                if iRow == iCol
                    continue;
                end
                originalRow = categoryNameMap(newCategoryNameList{iRow});
                originalCol = categoryNameMap(newCategoryNameList{iCol});
                newMatrix(iRow,iCol) = matrix(originalRow,originalCol);
            end
        end
        
        % update matrix and categoryName
        matrix = newMatrix;
        categoryNameList = newCategoryNameList;
    end
    categoryNameHierarchy = containers.Map(categoryNameParent,categoryNameChildren);
end