function h = sim2hierar( dist_file, leaves_file)

% processing leave nodes
fileID = fopen(leaves_file,'r');
data = fscanf(fileID,'%s');
data = strrep(data, ']', '');
data = strrep(data, '[', '');
data = strrep(data, '"', '');
nodes = strsplit(data, ',');

% processing distance matrix
fileID = fopen(dist_file,'r');
data = fscanf(fileID,'%s');
data = strrep(data, ']', '');
data = strrep(data, '[', '');
data = strrep(data, '"', '');
str_dists = strsplit(data, ',');
dists = cellfun(@str2num, str_dists);

% hierarchical clustering
z = linkage(dists, 'average');
d = dendrogram(z, length(nodes),'Labels', nodes,'Orientation','left'); % function usually acepts until 30 leaves, add second parameter to avoid this
% xlim([0.65, 0.95])

% save hierarchy in a map structure
h_map = containers.Map();
c = length(nodes) + 1;

for i = 1:size(z,1)
    row = z(i,:);
    ix_child1 = row(1);
    ix_child2 = row(2);
    
    if ix_child1 <= length(nodes)
        child1 = nodes{ix_child1};
    else
        child1 = num2str(ix_child1);
    end
    if ix_child2 <= length(nodes)
        child2 = nodes{ix_child2};
    else
        child2 = num2str(ix_child2);
    end
    vals = {child1, child2};
    k = num2str(c);
    h_map(k) = vals;
    c = c + 1;
end
h = h_map;

end