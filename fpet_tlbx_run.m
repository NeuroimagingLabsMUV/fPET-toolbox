function fpet_tlbx_run(src)
% fPET toolbox: gui run fpetbacth function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
global fpetbatch;
handles = guidata(src);
% Call the wrapper function to check if fpetbatch need to be updated
fpetbatch = updateDefaultsWrapper(handles, fpetbatch);
if isfield(handles, 'SavedInputs')
    if isfield(handles.SavedInputs, 'T1R4C2')
        fpetbatch.glm.in.data = (handles.SavedInputs.T1R4C2); %glm
    end
    if isfield(handles.SavedInputs, 'T2R3C2')
        fpetbatch.glm.in.mask.bl_excl = (handles.SavedInputs.T2R3C2);   %glm excl mask
    end
    if isfield(handles.SavedInputs, 'T7R3C2')
        fpetbatch.tacplot.in.dir = (handles.SavedInputs.T7R3C2); %TAC
    end
    if isfield(handles.SavedInputs, 'T8R2C2')
        fpetbatch.conn.in.data = (handles.SavedInputs.T8R2C2); %conn
    end
    if isfield(handles.SavedInputs, 'T10R2C2')
        fpetbatch.cov.in.data = (handles.SavedInputs.T10R2C2); %cov
    end
    if isfield(handles.SavedInputs, 'T11R2C2')
        fpetbatch.ica.in.data = (handles.SavedInputs.T11R2C2); %ica
    end
end
fpet_tlbx(fpetbatch);
end