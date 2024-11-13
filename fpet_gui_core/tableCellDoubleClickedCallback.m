function tableCellDoubleClickedCallback(src, event)
% fPET toolbox: Table mouse click listener
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria

handles = guidata(src);
% Check if any cell was clicked
if isempty(event.Indices)
    return;
end
selectedRow = event.Indices(1);
selectedColumn = event.Indices(2);
currentValue = src.Data{selectedRow, selectedColumn};
handles.TextArea.Value = getInfoText(handles.Menu, selectedRow);

% Check the interaction type for the selected row
interactionType = handles.InteractionTypes(handles.Menu, selectedRow);

if selectedColumn == 2
    switch interactionType
        case 1
            handleTrueFalseInteraction(src, selectedRow, selectedColumn, currentValue);
        case 2
            handleFreeTextInteraction(src, selectedRow, selectedColumn, currentValue);
        case 3
            handleImageMatSelectionInteraction(src, selectedRow, selectedColumn, 4);
        case 4
            handleImageMatSelectionInteraction(src, selectedRow, selectedColumn, 3);
        case 5
            handleTemporalInputInteraction(src, selectedRow, selectedColumn, currentValue);
        case 6
            handleBLValueInteraction(src, selectedRow, selectedColumn, currentValue);
        case 7
            addTaskRegressor(handles);
        case 8
            copyTaskRegressor(handles);
        case 9
            removeTaskRegressor(handles);
        case 10
            handleImageMatSelectionInteraction(src, selectedRow, selectedColumn, 1);
        case 11
            handleImageMatSelectionInteraction(src, selectedRow, selectedColumn, 2);
        case 12
            handlePlasmaValueInteraction(src, selectedRow, selectedColumn, currentValue);
        case 13
            handleQuantValueInteraction(src, selectedRow, selectedColumn, currentValue);
        case 14
            handleVectorValueInteraction(src, selectedRow, selectedColumn, currentValue);
        case 15
            handleImageMatSelectionInteraction(src, selectedRow, selectedColumn, 5);
        case 16
            handleConnValueInteraction(src, selectedRow, selectedColumn, currentValue);
        case 17
            handlePadValueInteraction(src, selectedRow, selectedColumn, currentValue);
        case 18
            handleBPValueInteraction(src, selectedRow, selectedColumn, currentValue);
    end
end
end