%Case 17: Padding at beginning or end or none
function handlePadValueInteraction(table, selectedRow, selectedColumn, currentValue)
% fPET toolbox: handler function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
if currentValue == 1 %strcmp(currentValue, '1')
    displayValue = 'Beginning';
elseif currentValue == 2 %strcmp(currentValue, '2')
    displayValue = 'End';
elseif currentValue == 0 %strcmp(currentValue, '3')
    displayValue = 'None';
else
    displayValue = ''; % Handle other unexpected values
end
% Dropdown with custom inputs
newFig = uifigure('Name', 'Edit Value', 'Position', [300, 300, 300, 150], 'WindowStyle', 'modal');
dropdown = uidropdown(newFig, 'Items', {'', 'Beginning', 'End', 'None'}, 'Position', [20, 70, 260, 22]);
dropdown.Value = displayValue;
uibutton(newFig, 'Text', 'Save', 'Position', [100, 20, 100, 30], ...
    'ButtonPushedFcn', @(btn, event) saveBLValue(btn, dropdown, table, selectedRow, selectedColumn, newFig));
end
