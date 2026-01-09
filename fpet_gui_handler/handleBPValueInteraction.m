function handleBPValueInteraction(table, selectedRow, selectedColumn, currentValue)
% fPET toolbox: handler function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
if isempty(currentValue)
    currentValue = '0 - 0';
end
bpVals = split(currentValue, ' - ');
newFig = uifigure('Name', 'Edit Value', 'Position', [300, 300, 300, 150], 'WindowStyle', 'modal');
editField = uieditfield(newFig, 'text', 'Value', bpVals{1}, 'Position', [20, 70, 100, 22]);
editField2 = uieditfield(newFig, 'text', 'Value', bpVals{2}, 'Position', [140, 70, 100, 22]);
uibutton(newFig, 'Text', 'Save', 'Position', [100, 20, 100, 30], ...
    'ButtonPushedFcn', @(btn, event) saveFreeBPValue(btn, editField, editField2, table, selectedRow, selectedColumn, newFig));
end



