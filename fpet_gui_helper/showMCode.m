function showMCode(src, event)
% fPET toolbox: helper function 
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
    if isfield(handles.SavedInputs, 'T7R4C2')
        fpetbatch.tacplot.in.mask = (handles.SavedInputs.T7R4C2); %TAC
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
printfpetbatch = fpetbatch;
%remove module that are not set to run
if all(printfpetbatch.run_glm == 0) || isempty(printfpetbatch.run_glm)
    printfpetbatch = rmfield(printfpetbatch, 'glm');
    printfpetbatch = rmfield(printfpetbatch, 'run_glm');
end
if all(printfpetbatch.run_ica == 0) || isempty(printfpetbatch.run_ica)
    printfpetbatch = rmfield(printfpetbatch, 'ica');
    printfpetbatch = rmfield(printfpetbatch, 'run_ica');
end
if all(printfpetbatch.run_conn == 0) || isempty(printfpetbatch.run_conn)
    printfpetbatch = rmfield(printfpetbatch, 'conn');
    printfpetbatch = rmfield(printfpetbatch, 'run_conn');
end
if all(printfpetbatch.run_cov == 0) || isempty(printfpetbatch.run_cov)
    printfpetbatch = rmfield(printfpetbatch, 'cov');
    printfpetbatch = rmfield(printfpetbatch, 'run_cov');
end
if all(printfpetbatch.run_tacplot == 0) || isempty(printfpetbatch.run_tacplot)
    printfpetbatch = rmfield(printfpetbatch, 'tacplot');
    printfpetbatch = rmfield(printfpetbatch, 'run_tacplot');
end
if all(printfpetbatch.run_quant == 0) || isempty(printfpetbatch.run_quant)
    printfpetbatch = rmfield(printfpetbatch, 'run_quant');
    printfpetbatch = rmfield(printfpetbatch, 'quant');    
end
if all(printfpetbatch.run_psc == 0) || isempty(printfpetbatch.run_psc)
    printfpetbatch = rmfield(printfpetbatch, 'run_psc');   
end
% Convert the fpetbatch structure to a full readable .m code format
codeStr = recursiveStructToString(printfpetbatch, 'fpetbatch', 0);

% Create a new figure window to display the code
hFig = figure('Name', 'Show .m Code', 'NumberTitle', 'off', 'MenuBar', 'none', ...
    'ToolBar', 'none', 'Resize', 'on');

% Create a uicontrol to display the code in a multi-line text box
uicontrol('Style', 'edit', 'Max', 2, 'Min', 0, 'String', codeStr, ...
    'HorizontalAlignment', 'left', 'FontName', 'Courier', ...
    'FontSize', 10, 'Units', 'normalized', ...
    'Position', [0 0 1 1], 'BackgroundColor', 'white');

% Set the figure size for better viewing
set(hFig, 'Position', [300, 300, 600, 400]); % Adjust position and size as needed
end