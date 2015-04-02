function m = merge_nodes( node )
   if strcmp(class(node{1}), 'char')
       % base case
       m = node;
   else
       % recursive case
       ms = {};
       for i=1: length(node)
           child = node{i};
           m0 = merge_nodes(child);
           ms = [ms; m0];
       end
       m = ms;
   end   
end

