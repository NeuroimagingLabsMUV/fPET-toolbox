function openBatch(src, event)
% fPET toolbox: helper function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
global fpetbatch;
[file, path] = uigetfile('*.mat', 'Open Batch File');
if isequal(file, 0)
    disp('User canceled the open.');
else
    fullFileName = fullfile(path, file);
    loadedData = load(fullFileName);
    if isfield(loadedData, 'fpetbatch')
        fpetbatch = loadedData.fpetbatch;
    end
end
handles = guidata(src);
handles.SavedInputs.T1R4C2 = fpetbatch.glm.in.data; %glm
handles.SavedInputs.T2R3C2 = fpetbatch.glm.in.mask.bl_excl;   %glm mask
handles.SavedInputs.T7R4C2 = fpetbatch.tacplot.in.dir;%TAC
handles.SavedInputs.T8R2C2 = fpetbatch.conn.in.data;%conn
handles.SavedInputs.T10R2C2 = fpetbatch.cov.in.data; %cov
handles.SavedInputs.T11R2C2 = fpetbatch.ica.in.data;%ica
fpetbatch = updateDefaultsWrapper(handles, fpetbatch);


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