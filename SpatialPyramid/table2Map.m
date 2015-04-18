function dataMap = table2Map(dataTable, fn)
    C = table2cell(dataTable)
    dataMap = containers.Map(C(:,1),C(:,2));
    save(fn, 'dataMap');
end