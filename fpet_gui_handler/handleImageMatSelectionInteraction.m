function handleImageMatSelectionInteraction(table, selectedRow, selectedColumn, caseId)
% fPET toolbox: handler function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
switch caseId
    case 1 % single Nifti input
        input = selectFilesFromMultipleFolders('*.nii', 'Load Nifti File', 'off');
        
    case 2 % single mat or txt input
        input = selectFilesFromMultipleFolders({'*.txt', 'Input Files'}, 'Load Input File', 'off');
        
    case 3 % multiple Nifti inputs
        input = selectFilesFromMultipleFolders('*.nii', 'Load Nifti Files', 'on');
        
    case 4 % single directory input
        dirPath = uigetdir(pwd, 'Select Directory');
        if dirPath == 0
            input = cellstr('');
        else
            input = cellstr(dirPath);
        end
        
    case 5 % multiple mat input
        input = selectFilesFromMultipleFolders('*.mat', 'Load fPET.mat Files', 'on');
end

handles = guidata(table);

if size(input,1) > 1
    tmp = sprintf('%dx%d Data array', size(input'));
else
    tmp = cell2mat(input);
end

if handles.Menu == 1 && selectedRow == 4
    handles.SavedInputs.T1R4C2 = cell2mat(input); %glm
end
if handles.Menu == 2 && selectedRow == 3
    handles.SavedInputs.T2R3C2 = input';
end
% if handles.Menu == 7 && selectedRow == 4
%     handles.SavedInputs.T7R4C2 = cell2mat(input);
% end
if handles.Menu == 7 && selectedRow == 3
    handles.SavedInputs.T7R3C2 = input';
end
if handles.Menu == 8 && caseId == 1 && selectedRow == 2
    handles.SavedInputs.T8R2C2 = cell2mat(input);
end
if handles.Menu == 10  && selectedRow == 2
    handles.SavedInputs.T10R2C2 = input';
end
if handles.Menu == 11
    handles.SavedInputs.T11R2C2 = input';
end


guidata(table, handles);


table.Data{selectedRow, selectedColumn} = tmp;
table.Selection(2) = 1;
figure(ancestor(table, 'figure'));  % Get the parent figure from src

end

