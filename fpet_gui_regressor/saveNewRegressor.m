% Callback for saving the new task regressor
function saveNewRegressor(btn, regressorNameField, regressorOnsetField, regressorDurationField, handles, newFig)
% fPET toolbox: save regressor 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
regressorName = regressorNameField.Value;
regressorOnset = regressorOnsetField.Value;
regressorDuration = regressorDurationField.Value;
handles.TaskRegressors = [handles.TaskRegressors; {regressorName, ['Onset: ' num2str(regressorOnset) ' - End: ' num2str(regressorDuration)]}];
newData = handles.TaskRegressors;
tableData = [getTableBaseData(handles.Menu); newData];
handles.Table.Selection(2) = 1;
updateTable(handles.Table, tableData);
guidata(handles.Table, handles);
close(newFig);
end
