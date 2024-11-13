% Callback for copying a task regressor to the table
function copyRegressorToTable(btn, dropdown, newRegName, handles, newFig)
% fPET toolbox: copy regressor function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
selectedRegressor = handles.TaskRegressors{strcmp(handles.TaskRegressors(:,1), dropdown.Value),2};
newRegressor = {newRegName.Value, selectedRegressor};
handles.TaskRegressors = [handles.TaskRegressors; newRegressor];
newData = handles.TaskRegressors;
handles.Table.Selection(2) = 1;
tableData = [getTableBaseData(handles.Menu); newData];
updateTable(handles.Table, tableData);
guidata(handles.Table, handles);
close(newFig);
end