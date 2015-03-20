sample=k_test(1,1);
j=1;
for i=31:3000
    ratio(j)=sample/k_test(1,i);
    j=j+1;
end
mean(ratio)
