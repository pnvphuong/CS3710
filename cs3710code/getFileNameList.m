function fnList = getFileNameList(folderList)
    fnList = {};
    for i = 1 : length(folderList)
        dirData = dir(folderList{i});
        dirIndex = [dirData.isdir];  %# Find the index for directories
        fileList = {dirData(~dirIndex).name}';  %'# Get a list of the files
        for j = 1 : length(fileList)
            fnList = [fnList; strcat(folderList{i}, '/', fileList{j})];
        end
    end
end