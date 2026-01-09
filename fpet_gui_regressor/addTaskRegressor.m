% Case 7: Add Task Regressor Interaction
function addTaskRegressor(handles)
% fPET toolbox: add regressor function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
newFig = uifigure('Name', 'Add Task Regressor', 'Position', [300, 300, 300, 200], 'WindowStyle', 'modal');
uilabel(newFig, 'Position', [20, 160, 100, 22], 'Text', 'Regressor Name:');
regressorNameField = uieditfield(newFig, 'text', 'Value', '', 'Position', [20, 140, 260, 22]);
uilabel(newFig, 'Position', [20, 120, 100, 22], 'Text', 'Onset:');
regressorOnsetField = uieditfield(newFig, 'text', 'Value', '', 'Position', [20, 100, 260, 22]);
uilabel(newFig, 'Position', [20, 80, 100, 22], 'Text', 'End:');
regressorDurationField = uieditfield(newFig, 'text', 'Value', '', 'Position', [20, 60, 260, 22]);

uibutton(newFig, 'Text', 'Save', 'Position', [100, 20, 100, 30], ...
    'ButtonPushedFcn', @(btn, event) saveNewRegressor(btn, regressorNameField, regressorOnsetField, regressorDurationField, handles, newFig));
end

