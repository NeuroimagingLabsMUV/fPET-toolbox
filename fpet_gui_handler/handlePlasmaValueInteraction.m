%Case 12: 
function handlePlasmaValueInteraction(table, selectedRow, selectedColumn, currentValue)
% fPET toolbox: handler function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
if currentValue == 1 %strcmp(currentValue, '1')
    displayValue = 'Average';
elseif currentValue == 2 %strcmp(currentValue, '2')
    displayValue = 'Linear Fit';
else
    displayValue = currentValue; % Handle other unexpected values
end
% Dropdown with custom inputs
newFig = uifigure('Name', 'Edit Value', 'Position', [300, 300, 300, 150]);
dropdown = uidropdown(newFig, 'Items', {'Average', 'Linear Fit'}, 'Position', [20, 70, 260, 22]);
dropdown.Value = displayValue;
uibutton(newFig, 'Text', 'Save', 'Position', [100, 20, 100, 30], ...
    'ButtonPushedFcn', @(btn, event) saveBLValue(btn, dropdown, table, selectedRow, selectedColumn, newFig));
end


