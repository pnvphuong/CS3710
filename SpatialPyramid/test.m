A = [1 0 0; 0 1 0; 1 0 0; 0 0 1; 1 0 0; 0 1 0]
B = [1 0 0; 1 0 0; 1 0 0; 0 0 1; 1 0 0; 1 0 0]

A & B
sum(sum(A&B)) / (length(A) + length(B))