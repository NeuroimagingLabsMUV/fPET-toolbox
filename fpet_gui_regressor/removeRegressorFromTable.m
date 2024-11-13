% Callback for removing a task regressor from the table
function removeRegressorFromTable(btn, dropdown, handles, newFig)
% fPET toolbox: remove regressor function
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
selectedRegressor = dropdown.Value;
indexToRemove = find(strcmp(handles.TaskRegressors(:, 1), selectedRegressor));
handles.TaskRegressors(indexToRemove, :) = [];
newData = handles.TaskRegressors;
handles.Table.Selection(2) = 1;
tableData = [getTableBaseData(handles.Menu); newData];
updateTable(handles.Table, tableData);
guidata(handles.Table, handles);
close(newFig);
end


