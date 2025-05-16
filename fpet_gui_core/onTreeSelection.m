function onTreeSelection(src, event)
% fPET toolbox: menu treee creation
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria

    % Retrieve the current handles structure
    global fpetbatch;
    handles = guidata(src);

    % Get the selected node
    selectedNode = event.SelectedNodes;
    if isempty(selectedNode)
        return;
    end
    % Call the wrapper function to check if fpetbatch need to be updated
    fpetbatch = updateDefaultsWrapper(handles, fpetbatch);
    % Update handles.Menu based on the selected node
    switch selectedNode.Text
        case 'General Settings'
            handles.Menu = 13;
            updateTable(handles.Table, {'Results Directory',fpetbatch.dir.result; 'Auto-overwrite?', convertBinaryToTrueFalse(fpetbatch.overwrite);});
        case 'Basic Settings'
            handles.Menu = 1;
            updateTable(handles.Table, {'Run GLM [*]', convertBinaryToTrueFalse(fpetbatch.run_glm); 'Input Image Data [*]', covertNiiToDesc(fpetbatch.glm.in.data); 'Frame Length [*]', num2str(fpetbatch.glm.in.framelength); 'Temporal Input [*]', convertValtoName(fpetbatch.glm.in.time)});
        case 'Baseline Definitions and masking'
            handles.Menu = 2;
            if size(fpetbatch.glm.in.mask.bl_excl,2) > 1
                tmp = sprintf('%dx%d Data array', size(fpetbatch.glm.in.mask.bl_excl'));
            else
                tmp = cell2mat(fpetbatch.glm.in.mask.bl_excl);
            end           
            updateTable(handles.Table, {'Baseline Mask [*]', fpetbatch.glm.in.mask.bl; 'Exclude Mask Threshold', char(strjoin(string(fpetbatch.glm.in.mask.th), ',')); 'Baseline Exclude Mask(s)', tmp; 'Baseline definition', convertValtoBL(fpetbatch.glm.in.bl_type); 'GLM Calculation Mask', fpetbatch.glm.in.mask.calc; 'Startpoint Of Baseline Fit', num2str(fpetbatch.glm.in.bl_start_fit)});
        case 'Filtering and nuissance regression'
            handles.Menu = 3;
            updateTable(handles.Table, {'Low-pass Filter', convertBinaryToTrueFalse(fpetbatch.glm.in.fil.apply); 'Filter Order', num2str(fpetbatch.glm.in.fil.order); 'Filter Cut-Off Frequency', num2str(fpetbatch.glm.in.fil.cutoff); 'Motion Regressors', fpetbatch.glm.in.regr_motion; 'Apply PCA to Regressors', convertBinaryToTrueFalse(fpetbatch.glm.in.regr_motion_pca); 'Additional Regressors', fpetbatch.glm.in.regr_add});
        case 'Task Regressors'
            regressorData = [];
            regressorData = handles.TaskRegressors;
            updateTable(handles.Table, [{'Add Task Regressor', ''; 'Copy Task Regressor', ''; 'Remove Task Regressor', ''}; regressorData]);
            handles.Menu = 4;
        case 'Quantification/PSC'
            handles.Menu = 5;
            updateTable(handles.Table, {'Estimate Percent Signal Change [*]', convertBinaryToTrueFalse(fpetbatch.run_psc); 'Quantify Data [*]', convertBinaryToTrueFalse(fpetbatch.run_quant); 'Temporal Input For Quatification [*]', convertValtoQuant(fpetbatch.quant.in.time); 'Whole-Blood Input', fpetbatch.quant.in.wb; 'Blood Plasma Input', fpetbatch.quant.in.plasma; 'Plasma/Whole-Blood Ratio', fpetbatch.quant.in.pwbr; 'Parent Fraction', fpetbatch.quant.in.parent; 'Fit Method', convertValtoPlasma(fpetbatch.quant.in.pwbr_fit); 'Lumped Constant', num2str(fpetbatch.quant.in.lc); 'Fractional Whole-Blood Volume', num2str(fpetbatch.quant.in.vb); 'Blood Glucose Level', num2str(fpetbatch.quant.in.bloodlvl); 'T-Star', num2str(fpetbatch.quant.in.tstar)});
        case 'Advanced Settings'
            handles.Menu = 6;
            updateTable(handles.Table, {'Pad incomplete motion regressors at', convertValtoPad(fpetbatch.glm.in.regr_motion_incomplete); 'Orthogonalize Regressors', convertBinaryToTrueFalse(fpetbatch.glm.in.regr_orth); 'Weight GLM', num2str(fpetbatch.glm.in.weight); 'Remove Inital Timepoints', num2str(fpetbatch.glm.in.rem_start); 'Remove Final Timepoints', num2str(fpetbatch.glm.in.rem_end); 'Data Incomplete?', convertBinaryToTrueFalse(fpetbatch.glm.in.data_incomplete.flag); 'Start Time of Missing Data', num2str(fpetbatch.glm.in.data_incomplete.start); 'End Times of Missing Data', num2str(fpetbatch.glm.in.data_incomplete.end)});
        case 'TAC Plot'
            handles.Menu = 7;
            if isfield(handles,'SavedInputs')
                if size(handles.SavedInputs.T7R3C2,2) > 1
                    tmp = sprintf('%dx%d Data array', size(handles.SavedInputs.T7R3C2));
                else
                    tmp = cell2mat(handles.SavedInputs.T7R3C2);
                end
            else
                tmp = []; handles.SavedInputs.T7R3C2 = [];
            end
            updateTable(handles.Table, {'Run TAC Plot [*]', convertBinaryToTrueFalse(fpetbatch.run_tacplot); 'Number of Regressors to be Plotted [*]', num2str(fpetbatch.tacplot.in.regr); 'Input fPET.mat Files [*]', tmp; 'TAC Mask [*]', fpetbatch.tacplot.in.mask; 'Plot Idividual TACs', convertBinaryToTrueFalse(fpetbatch.tacplot.in.indiv); 'Plot Average TAC', convertBinaryToTrueFalse(fpetbatch.tacplot.in.average); 'Plot Raw TAC', convertBinaryToTrueFalse(fpetbatch.tacplot.in.raw)});
        case 'Basic Connectivity Settings'
            handles.Menu = 8;
            updateTable(handles.Table, {'Run Connectivity [*]', convertBinaryToTrueFalse(fpetbatch.run_conn); 'Input Data [*]', covertNiiToDesc(fpetbatch.conn.in.data); 'Baseline Removal Technique [*]', convertValtoConn(fpetbatch.conn.in.bl_type); 'Start point for Baseline removal', num2str(fpetbatch.conn.in.bl_start_fit); 'Atlas', fpetbatch.conn.in.atlas; 'Motion Regressors', fpetbatch.conn.in.regr_motion; 'PCA Regressors', convertBinaryToTrueFalse(fpetbatch.conn.in.regr_motion_pca); 'Additional Regressors', convertValtoPad(fpetbatch.conn.in.regr_add); 'Baseline Mask [*]', covertNiiToDesc(fpetbatch.conn.in.mask_bl); 'Frame Length [*]', num2str(fpetbatch.conn.in.framelength); 'Temporal input [*]', convertValtoName(fpetbatch.conn.in.time)}); %'Filter Order', num2str(fpetbatch.conn.in.fil.order); 'Cutoff Frequency', [num2str(fpetbatch.conn.in.fil.cutoff(1)) ' - ' num2str(fpetbatch.conn.in.fil.cutoff(2))];
        case 'Advanced Connectivity Settings'
            handles.Menu = 9;
            updateTable(handles.Table, {'Remove Inital Frames', num2str(fpetbatch.conn.in.rem_start); 'Remove Final Frames', num2str(fpetbatch.conn.in.rem_end); 'Pad incomplete motion regressors at', convertValtoPad(fpetbatch.conn.in.regr_motion_incomplete)});
        case 'Covariance'
            if size(fpetbatch.cov.in.data,2) > 1
                tmp = sprintf('%dx%d Data array', size(fpetbatch.cov.in.data));
            else
                tmp = cell2mat(fpetbatch.cov.in.data);
            end   
            handles.Menu = 10;
            updateTable(handles.Table, {'Run Covariance [*]', convertBinaryToTrueFalse(fpetbatch.run_cov); 'Input Data [*]', tmp; 'Atlas [*]', fpetbatch.cov.in.atlas; 'Normalization Mask [*]', fpetbatch.cov.in.mask_norm; 'Regressors', fpetbatch.cov.in.regr_add});
        case 'ICA'
            if size(fpetbatch.ica.in.data,2) > 1
                tmp = sprintf('%dx%d Data array', size(fpetbatch.ica.in.data'));
            else
                tmp = cell2mat(fpetbatch.ica.in.data);
            end   
            handles.Menu = 11;
            updateTable(handles.Table, {'Run ICA [*]', convertBinaryToTrueFalse(fpetbatch.run_ica); 'Input Images [*]', tmp; 'Dimentionality Reduction', convertBinaryToTrueFalse(fpetbatch.ica.in.pca); 'Number of PCs for Dimentionality Reduction', num2str(fpetbatch.ica.in.pc); 'Number of Independent Components', num2str(fpetbatch.ica.in.ic); 'Remove Inital Timepoints', num2str(fpetbatch.ica.in.rem_start); 'Remove Final Timepoint', num2str(fpetbatch.ica.in.rem_end); 'Frame Length [*]', num2str(fpetbatch.ica.in.framelength); 'Temporal Input [*]', convertValtoName(fpetbatch.ica.in.time); 'Calculation Mask [*]', covertNiiToDesc(fpetbatch.ica.in.mask.calc)});
        case 'Run Modules'
            handles.Menu = 12;
            updateTable(handles.Table, {'Run GLM', convertBinaryToTrueFalse(fpetbatch.run_glm); 'Run PSC', convertBinaryToTrueFalse(fpetbatch.run_psc); 'Run Quantification', convertBinaryToTrueFalse(fpetbatch.run_quant); 'Run TAC Plot', convertBinaryToTrueFalse(fpetbatch.run_tacplot); 'Run ICA', convertBinaryToTrueFalse(fpetbatch.run_ica); 'Run Connectivity', convertBinaryToTrueFalse(fpetbatch.run_conn); 'Run Covariance', convertBinaryToTrueFalse(fpetbatch.run_cov); });
            runButton = uibutton(handles.Table.Parent, 'Text', 'Run', 'Position', [500, 350, 100, 30], ...
                                 'ButtonPushedFcn', @(btn, event) fpet_tlbx_run(src));
            handles.RunButton = runButton;
    end
    if handles.Menu ~= 12
        handles.RunButton.Visible = 'off';
    end
    % Store the updated handles structure
    guidata(src, handles);
end
