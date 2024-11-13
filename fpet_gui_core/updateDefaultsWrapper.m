function fpetbatch = updatefpetbatchWrapper(handles, fpetbatch)
% fPET toolbox: fpetbatch batch wrapper function
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria

currentTableData = handles.Table.Data;
    if ~isequal(currentTableData, handles.PreviousTableData)
       % Update the fpetbatch variable with the new table data
       fpetbatch = updateDefaults(handles, fpetbatch);
       %handles.PreviousTableData = currentTableData; % Update stored data
       %guidata(src, handles);
    end
end