function fpet_tlbx_gui()
% fPET toolbox: gui caller function
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
global fpetbatch; 
fpetbatch = fpet_tlbx_defaults();
% Create the main figure using uifigure
fig = uifigure('Name', 'fPET Toolbox', 'Position', [100, 100, 800, 600]);


% Create the tree
tree = uitree(fig, 'Position', [10, 10, 230, 580]);
GEN = uitreenode(tree, 'Text', 'General Settings');
GLM = uitreenode(tree, 'Text', 'GLM');
ICA = uitreenode(tree, 'Text', 'ICA');
CON = uitreenode(tree, 'Text', 'Connectivity');
COV = uitreenode(tree, 'Text', 'Covariance');
RUN = uitreenode(tree, 'Text', 'Run Modules');

% Add subnodes to fPET Task
uitreenode(GLM, 'Text', 'Basic Settings');
uitreenode(GLM, 'Text', 'Baseline Definitions and masking');
uitreenode(GLM, 'Text', 'Filtering and nuissance regression');
uitreenode(GLM, 'Text', 'Task Regressors');
uitreenode(GLM, 'Text', 'Quantification/PSC');
uitreenode(GLM, 'Text', 'Advanced Settings');
uitreenode(GLM, 'Text', 'TAC Plot');
uitreenode(CON, 'Text', 'Basic Connectivity Settings');
uitreenode(CON, 'Text', 'Advanced Connectivity Settings');

% Create menu bar
fileMenu = uimenu(fig, 'Text', 'File');
uimenu(fileMenu, 'Text', 'New Batch', 'MenuSelectedFcn',  @(src, event) newBatch(src, event));
uimenu(fileMenu, 'Text', 'Open Batch', 'MenuSelectedFcn', @(src, event) openBatch(src, event));
uimenu(fileMenu, 'Text', 'Save Batch', 'MenuSelectedFcn', @(src, event) saveBatch(src, event));

editMenu = uimenu(fig, 'Text', 'Edit');
uimenu(editMenu, 'Text', 'Show .m Code', 'MenuSelectedFcn', @(src, event) showMCode(src, event));

    table = uitable(fig, 'Position', [250, 90, 540, 480], ...
        'ColumnName', {'Input', 'Value'}, ...
        'ColumnEditable', [false, true], ...
        'ColumnWidth', {230, 300}, ...
        'CellEditCallback', @tableCellEditCallback, ... 
        'CellSelectionCallback', @tableCellDoubleClickedCallback);

% Create the text area
textArea = uitextarea(fig, 'Position', [250, 10, 540, 70], 'Editable', 'off');
handles = guihandles(fig);
handles.Tree = tree;
handles.Table = table;
handles.TextArea = textArea;
handles.TaskRegressors = {}; % Store task regressors

handles.InteractionTypes =  [[1, 10, 2, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0]; ...        %GLM - basic
                            [10, 2, 4, 6, 10, 2, 0, 0, 0, 0, 0, 0, 0]; ...        %GLM - mask
                            [1, 2, 2, 11, 1, 11, 0, 0, 0, 0, 0, 0, 0]; ...        %GLM - fltr
                            [2, 7, 8, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0]; ...          %GLM - regrs
                            [1, 1, 13, 11, 11, 11, 2, 12, 2, 2, 2, 2, 0]; ...     %GLM - quant
                            [17, 1, 14, 2, 2, 1, 2, 2, 0, 0, 0, 0, 0]; ...        %GLM - adv
                            [1, 2, 15, 4, 1, 1, 1, 0, 0, 0, 0, 0, 0]; ...         %tacplot
                            [1, 10, 16, 2, 4, 2, 18, 11, 1, 11, 10, 2, 5]; ...    %connetivity - basic
                            [2, 2, 17, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; ...         %connectivity - adv
                            [1, 4, 10, 4, 11, 0, 0, 0, 0, 0, 0, 0, 0]; ...        %covariance
                            [1, 4, 1, 2, 2, 2, 2, 2, 5, 10, 0, 0, 0]; ...         %ica
                            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; ...          %run
                            [3, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0,0, 0]];              %Mandatory settings
handles.PreviousTableData = table.Data; % Store the previous table data for comparison
handles.Menu = 0;
guidata(fig, handles);
tree.SelectionChangedFcn = @(src, event) onTreeSelection(src, event);
end
