% Case 5: Temporal Input Interaction
function handleTemporalInputInteraction(table, selectedRow, selectedColumn, currentValue)
% fPET toolbox: handler function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
if currentValue == 1 %strcmp(currentValue, '1')
    displayValue = 'Seconds';
elseif currentValue == 2 % strcmp(currentValue, '2')
    displayValue = 'Frames';
else
    displayValue = ''; % Handle other unexpected values
end
% Dropdown with custom inputs
newFig = uifigure('Name', 'Edit Value', 'Position', [300, 300, 300, 150]);
dropdown = uidropdown(newFig, 'Items', {'','Frames', 'Seconds'}, 'Position', [20, 70, 260, 22]);
dropdown.Value = displayValue;
uibutton(newFig, 'Text', 'Save', 'Position', [100, 20, 100, 30], ...
    'ButtonPushedFcn', @(btn, event) saveTemporalValue(btn, dropdown, table, selectedRow, selectedColumn, newFig));
end

