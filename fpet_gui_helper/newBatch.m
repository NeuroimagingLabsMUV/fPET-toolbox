function newBatch(src, event)
% fPET toolbox: helper function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
% Create a new batch (fpetbatch)
global fpetbatch;
fpetbatch = fpet_tlbx_defaults(); % Reset to default values
% Find the main figure    
    % Retrieve the handles structure
    handles = guidata(src);
    % Call the wrapper function to check if defaults need to be updated
    fpetbatch = updateDefaultsWrapper(handles, fpetbatch);
    
    % Find the "GLM" node in the tree
    glmNode = findobj(handles.Tree, 'Text', 'Basic Settings');
    if isempty(glmNode)
        error('"GLM" node not found in the tree.');
    end
    collapseAllTreeNodes(handles.Tree);
    % Set the "GLM" node as selected
    handles.Tree.SelectedNodes = glmNode;
    handles.Menu = 1;
    % Update the UI based on the selected node
    onTreeSelection(handles.Tree, struct('SelectedNodes', glmNode));
    
    % Store the updated handles structure
    guidata(src, handles);
figure(ancestor(src, 'figure'));  % Get the parent figure from src

end
