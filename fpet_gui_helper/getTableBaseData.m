function tableData = getTableBaseData(menuType)
% fPET toolbox: helper function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
global fpetbatch;
switch menuType
    case 1
        tableData = {'Overwrite?', convertBinaryToTrueFalse(1); 'Working Directory', ''; 'Input Image Data', ''; 'Frame Length', ''; 'Temporal Input', ''};
    case 2
        tableData = {'Baseline Mask(s)', ''; 'Mask Threshold', ''; 'Baseline definition', ''};
    case 3
        tableData = {'Low-pass Filter', convertBinaryToTrueFalse(0); 'Filter Order', ''; 'Filter Cut-Off Frequency', ''; 'Motion Regressors', ''; 'Apply PCA to Regressors', convertBinaryToTrueFalse(0); 'Additional Regressors', ''};
    case 4
        tableData = {'Stimulus duration', num2str(fpetbatch.glm.in.stim_dur); 'Add Task Regressor', ''; 'Copy Task Regressor', ''; 'Remove Task Regressor', ''};
    case 5
        tableData = {'Estimate Percent Signal Change', convertBinaryToTrueFalse(0); 'Quantify data', convertBinaryToTrueFalse(0)};
    case 6
        tableData = {'Pad motion regressors at', ''; 'Orthogonalize Regressors', convertBinaryToTrueFalse(0); 'Start GLM Estimation at', ''; 'End GLM Estimation at', ''; 'Add Anchor Point', convertBinaryToTrueFalse(0)};
    otherwise
        tableData = {};
end
end

