% Case 1: True/False Interaction
function handleTrueFalseInteraction(table, selectedRow, selectedColumn, currentValue)
% fPET toolbox: handler function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
if strcmp(currentValue, 'true')
    displayValue = 'true';
elseif strcmp(currentValue, 'false')
    displayValue = 'false';
else
    displayValue = currentValue;
end
newFig = uifigure('Name', 'Edit Value', 'Position', [300, 300, 300, 150]);
dropdown = uidropdown(newFig, 'Items', {'', 'true', 'false'}, 'Position', [20, 70, 260, 22]);
dropdown.Value = displayValue;
uibutton(newFig, 'Text', 'Save', 'Position', [100, 20, 100, 30], ...
    'ButtonPushedFcn', @(btn, event) saveTrueFalseValue(btn, dropdown, table, selectedRow, selectedColumn, newFig));
end


