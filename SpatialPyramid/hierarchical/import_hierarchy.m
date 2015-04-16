% h = import_hierarchy('wordnet_hierarchy.txt')
function h = import_hierarchy(file_name)
% data
fileID = fopen(file_name,'r');
data = fscanf(fileID,'%s');

h_map = containers.Map();
data = strrep(data, '],', '];');
data = regexprep(data, '[}{]','');

sp = strsplit(data, ';');

for i = 1: length(sp) % go over all the elements of the array    
    s = sp{i};
    sp_el = strsplit(s, ':');
    key = strrep(sp_el{1}, '"', '');
    val_int = strrep(sp_el{2}, '"', '');
    val_int = strrep(val_int, '[', '');
    val_int = strrep(val_int, ']', '');
    val = strsplit(val_int, ',');
    val = val(2:end);
    h_map(key) = val;
end
h = h_map;