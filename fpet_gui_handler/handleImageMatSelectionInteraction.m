function handleImageMatSelectionInteraction(table, selectedRow, selectedColumn, caseId)
% fPET toolbox: handler function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria

switch caseId
    case 1 % single Nifti input
        [file, path] = uigetfile('*.nii', 'Load Nifti File' , 'MultiSelect', 'off');
        if file == 0
            input = '';
        else
            input = cellstr(fullfile(path, file));
        end
    case 2 % single mat or txt input
        [file, path] = uigetfile({'*.mat;*.xls;*.xlsx;*.txt;'}, 'Load Input File' , 'MultiSelect', 'off');
        if file == 0
            input = '';
        else
            input = cellstr(fullfile(path, file));
        end
    case 3 % multiple Nifti inputs
        [file, path] = uigetfile('*.nii', 'Load Nifti Files' , 'MultiSelect', 'on');
       
        if ~iscell(file) %size(file,1) <= 1
            if file == 0
                input = cellstr('');
            else
                input = cellstr(fullfile(path, file));
            end
        else
            input = fullfile(path, file)';
        end
    case 4 % single directory input
        input = cellstr(uigetdir(pwd, 'Select Directory'));
    case 5 % multiple mat input
        [file, path] = uigetfile('*.mat', 'Load fPET.mat Files' , 'MultiSelect', 'on');
        if size(path,1) <= 1
            input = cellstr(fullfile(path, file));
        else
            input = cellstr(fullfile(path, file)');
        end
end


handles = guidata(table);

if size(input,1) > 1
    tmp = sprintf('%dx%d Data array', size(input'));
else
    tmp = cell2mat(input);
end

if handles.Menu == 1
    handles.SavedInputs.T1R4C2 = cell2mat(input); %glm
end
if handles.Menu == 2
    handles.SavedInputs.T2R3C2 = input';
end
if handles.Menu == 7
    handles.SavedInputs.T7R4C2 = input';
end
if handles.Menu == 8 && caseId == 1
    handles.SavedInputs.T8R2C2 = cell2mat(input);
end
if handles.Menu == 10
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

