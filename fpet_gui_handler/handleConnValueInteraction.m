%Case 16: 
function handleConnValueInteraction(table, selectedRow, selectedColumn, currentValue)
% fPET toolbox: handler function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
if currentValue == 1 %strcmp(currentValue, '1')
    displayValue = 'Mask';
elseif currentValue == 2 %strcmp(currentValue, '2')
    displayValue = '3rd Order Polynomial Detrending (Global)';
elseif currentValue == 3 %strcmp(currentValue, '3')
    displayValue = '3rd Order Polynomial Detrending (per ROI)';
 elseif currentValue == 4
     displayValue = 'Spatio-temporal Filter';
 elseif currentValue == 5 %strcmp(currentValue, '4')
     displayValue = 'CompCor Filter';
elseif currentValue == 6
    displayValue = 'Baseline Normalization';
elseif currentValue == 7 
    displayValue = 'Euclidean distance';
else
    displayValue = currentValue; % Handle other unexpected values
end
% Dropdown with custom inputs
newFig = uifigure('Name', 'Edit Value', 'Position', [300, 300, 300, 150], 'WindowStyle', 'modal');
dropdown = uidropdown(newFig, 'Items', {'Mask', '3rd Order Polynomial Detrending (Global)', '3rd Order Polynomial Detrending (per ROI)', 'Spatio-temporal Filter', 'CompCor Filter', 'Baseline normalization', 'Euclidean distance'}, 'Position', [20, 70, 260, 22]); 
dropdown.Value = displayValue;
uibutton(newFig, 'Text', 'Save', 'Position', [100, 20, 100, 30], ...
    'ButtonPushedFcn', @(btn, event) saveBLValue(btn, dropdown, table, selectedRow, selectedColumn, newFig));
end
