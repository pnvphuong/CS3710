preClass = [1 -1 1 1 1 -1];
testClass = [1 1 -1 1 -1 -1];
posClass = preClass == 1;
posTestClass = testClass == 1;
sum(posClass & posTestClass) / length(preClass)