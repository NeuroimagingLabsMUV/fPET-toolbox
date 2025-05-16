function newBatch(src, event)
% fPET toolbox: helper function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
% Create a new batch (fpetbatch)
global fpetbatch;
clear fpetbatch;
fpetbatch = fpet_tlbx_defaults(); % Reset to default values
% Find the main figure    
    % Retrieve the handles structure
    handles = guidata(src);
    handles.SavedInputs.T1R4C2 = []; %glm
    handles.SavedInputs.T2R3C2 = [];   %glm mask
    handles.SavedInputs.T7R3C2 = []; %TAC
    handles.SavedInputs.T8R2C2 = [];%conn
    handles.SavedInputs.T10R2C2 = []; %cov
    handles.SavedInputs.T11R2C2 = [];%ica

    
    % Find the "GLM" node in the tree
    glmNode = findobj(handles.Tree, 'Text', 'General Settings');
    if isempty(glmNode)
        error('"General Settings" node not found in the tree.');
    end
    collapseAllTreeNodes(handles.Tree);
    % Set the "GLM" node as selected
    handles.Tree.SelectedNodes = glmNode;
    handles.Menu = 13;
    % Update the UI based on the selected node
    onTreeSelection(handles.Tree, struct('SelectedNodes', glmNode));
        % Call the wrapper function to check if defaults need to be updated
    fpetbatch = updateDefaultsWrapper(handles, fpetbatch);
    % Store the updated handles structure
    guidata(src, handles);
figure(ancestor(src, 'figure'));  % Get the parent figure from src

end
