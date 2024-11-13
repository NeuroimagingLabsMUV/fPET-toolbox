% Case 9: Remove Task Regressor Interaction
function removeTaskRegressor(handles)
% fPET toolbox: remove regressor #2 function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria

if ~isempty(handles.TaskRegressors)
    newFig = uifigure('Name', 'Remove Task Regressor', 'Position', [300, 300, 300, 150]);
    regressorList = handles.TaskRegressors(:, 1);
    dropdown = uidropdown(newFig, 'Items', regressorList, 'Position', [20, 70, 260, 22]);
    uibutton(newFig, 'Text', 'Remove', 'Position', [100, 20, 100, 30], ...
        'ButtonPushedFcn', @(btn, event) removeRegressorFromTable(btn, dropdown, handles, newFig));
else
    disp('no regressors to delete');
end
end
