function saveTemporalValue(btn, editField, table, selectedRow, selectedColumn, newFig)
% fPET toolbox: helper function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
newValue = editField.Value;
table.Data{selectedRow, selectedColumn} = newValue;
table.Selection(2) = 1;
close(newFig);
end
