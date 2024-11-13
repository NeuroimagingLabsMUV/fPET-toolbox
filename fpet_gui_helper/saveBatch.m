function saveBatch(src, event)
% fPET toolbox: helper function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
global fpetbatch;
handles = guidata(src);
% Call the wrapper function to check if fpetbatch need to be updated
fpetbatch = updateDefaultsWrapper(handles, fpetbatch);
if isfield(handles, 'SavedInputs')
    if isfield(handles.SavedInputs, 'T1R4C2')
        fpetbatch.glm.in.data = cellstr(handles.SavedInputs.T1R4C2); %glm
    end
    if isfield(handles.SavedInputs, 'T2R3C2')
        fpetbatch.glm.in.mask.bl_excl = cellstr(handles.SavedInputs.T2R3C2);   %glm mask
    end
    if isfield(handles.SavedInputs, 'T7R4C2')
        fpetbatch.tacplot.in.dir = cellstr(handles.SavedInputs.T7R4C2); %TAC
    end
    if isfield(handles.SavedInputs, 'T8R2C2')
        fpetbatch.conn.in.data = cellstr(handles.SavedInputs.T8R2C2); %conn
    end
    if isfield(handles.SavedInputs, 'T10R2C2')
        fpetbatch.cov.in.data = cellstr(handles.SavedInputs.T10R2C2); %cov
    end
    if isfield(handles.SavedInputs, 'T11R2C2')
        fpetbatch.ica.in.data = cellstr(handles.SavedInputs.T11R2C2); %ica
    end
end
[file, path] = uiputfile('*.mat', 'Save Batch As');
if isequal(file, 0)
    disp('User canceled the save.');
else
    fullFileName = fullfile(path, file);
    save(fullFileName, 'fpetbatch');
    disp(['Batch saved to ', fullFileName]);
end

end
