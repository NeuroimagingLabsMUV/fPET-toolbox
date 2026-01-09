% Case 2: Numeric Interaction
function handleFreeTextInteraction(table, selectedRow, selectedColumn, currentValue)
% fPET toolbox: handler function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
if isempty(currentValue)
    currentValue = '0';
end
newFig = uifigure('Name', 'Edit Value', 'Position', [300, 300, 300, 150], 'WindowStyle', 'modal');
editField = uieditfield(newFig, 'text', 'Value', currentValue, 'Position', [20, 70, 260, 22]);
uibutton(newFig, 'Text', 'Save', 'Position', [100, 20, 100, 30], ...
    'ButtonPushedFcn', @(btn, event) saveFreeTextValue(btn, editField, table, selectedRow, selectedColumn, newFig));
end

