% Case 8: Copy Task Regressor Interaction
function copyTaskRegressor(handles)
% fPET toolbox: copy regressor #2 function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
if ~isempty(handles.TaskRegressors)
    newFig = uifigure('Name', 'Copy Task Regressor', 'Position', [300, 300, 300, 150], 'WindowStyle', 'modal');
    % Assuming regressor copying involves selecting from an existing list
    regressorList = handles.TaskRegressors(:, 1);
    dropdown = uidropdown(newFig, 'Items', regressorList, 'Position', [20, 100, 260, 22]);
    uilabel(newFig, 'Position', [20, 80, 100, 22], 'Text', 'New Regressor Name:');
    newRegName = uieditfield(newFig, 'text', 'Value', '', 'Position', [20, 60, 260, 22]);
    uibutton(newFig, 'Text', 'Copy', 'Position', [100, 20, 100, 30], ...
        'ButtonPushedFcn', @(btn, event) copyRegressorToTable(btn, dropdown, newRegName, handles, newFig));
else
    disp('No regressors to copy');
end
end

