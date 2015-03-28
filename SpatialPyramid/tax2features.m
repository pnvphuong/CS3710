% function tax2features(tax, feat_folder)

% init data
warning('off','all'); % supress all warning messages
load('caltechTaxonomy.mat');
tax = caltechTaxonomyMap;
feat_folder = 'feat\';
image_dir = 'E:\nineil\phd\general_datasets\256_ObjectCategories\';
data_dir = 'data_feat_tax';

if exist(feat_folder, 'dir')~=7
    mkdir(feat_folder);
end

% TODO: verify if it is ok to generate at once all features or should they
% be separated at train and test phases

% TODO: verify if when buildPyramid should be all classes together or could
% be one by one

v = values(tax);
TF = [];
for i=1:length(v)
% for i=1:4
    fprintf('Exploring instace %d of total: %d', i , length(v));
    el = v{i};
    if iscell(el) == false
        folder_cat = [image_dir el];
        files_c = getFileNameList({folder_cat}); % extract name files
        
        % extract features of files
        files_c = cellfun(@(x) strrep(x, image_dir, ''), files_c, 'UniformOutput', false);
        feat = BuildPyramid(files_c,image_dir,data_dir); % features are in same order as files [VERIFIED]
        T = table(files_c, feat, 'VariableNames', {'file_name' 'feat_vector'});
        TF = [TF; T];
    end
end

% save table data
save([feat_folder 'feat_data'],'TF');

% NOTES
% in data foder search for the files *_pyramid_ [they have the feature
% vectors] e.g. 009_0001_pyramid_200_3% 