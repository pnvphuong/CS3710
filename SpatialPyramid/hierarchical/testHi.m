keySet1 =   {'Jan', 'Feb', 'Mar', 'Apr'};
valueSet1 = [327.2, 368.2, 197.6, 178.4];
mapObj1 = containers.Map(keySet1,valueSet1)

mapObj1('May') = 5

keySet2 =   {'abc'};
valueSet2 = [5];
mapObj2 = containers.Map(keySet2,valueSet2)