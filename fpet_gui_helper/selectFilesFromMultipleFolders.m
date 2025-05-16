function input = selectFilesFromMultipleFolders(fileFilter, dialogTitle, multiSelect)
% fileFilter: cell array or string for file types (e.g., '*.nii' or {'*.mat;*.txt','Input Files'})
% dialogTitle: custom title for the file selection dialog
% multiSelect: 'on' or 'off' for allowing multiple selections
input = {};
continueSelecting = true;
while continueSelecting
    [file, path] = uigetfile(fileFilter, dialogTitle, 'MultiSelect', multiSelect);
    
    if isequal(file, 0)
        if isempty(input)
            input = cellstr('');
        end
        break;
    end
    if iscell(file)
        fullPaths = fullfile(path, file);
    else
        fullPaths = {fullfile(path, file)};
    end
    
    input = [input, fullPaths];
    if strcmpi(multiSelect, 'on')
        userChoice = questdlg('Do you want to add more files?', ...
            'Add More Files?', ...
            'Yes', 'No', 'No');
        if strcmp(userChoice, 'No')
            continueSelecting = false;
        end
    else
        continueSelecting = false;
    end
end
input = input(:);
end
