function collapseAllTreeNodes(tree)
% fPET toolbox: helper function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
    % This function collapses all nodes in the provided tree
    nodes = tree.Children;  % Get all top-level nodes
    
    for i = 1:length(nodes)
        nodes(i).collapse;
    end
end