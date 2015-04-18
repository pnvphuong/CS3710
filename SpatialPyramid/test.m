<<<<<<< HEAD
% matrix = [0 1 4 2; 1 0 2 3; 4 2 0 1; 2 3 1 0];
% categoryNameHierarchy = hierarchyFromMatrix(matrix, {'A', 'B', 'C', 'D'});
% save('../data/GriffinHierarchy.mat', 'categoryNameHierarchy');
% buildClassifierHierarchy(categoryNameHierarchy);
=======
A = [1 0 0; 0 1 0; 1 0 0; 0 0 1; 1 0 0; 0 1 0]
B = [1 0 0; 1 0 0; 1 0 0; 0 0 1; 1 0 0; 1 0 0]

A & B
sum(sum(A&B)) / (length(A) + length(B))
>>>>>>> 086c83b761354cb6f36534f792e7bac76e30e854
