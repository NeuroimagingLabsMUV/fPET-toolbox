function text = getInfoText(menu, row)
% fPET toolbox: setting Variable descriptions
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria

text = '';
switch menu
    case 1
        switch row
            case 1
                text = {'Variable: fpetbatch.glm_run'; ''; '[Mandatory]'; ''; 'Flag used to indicate if the user wants to run the fPET GLM module (default: false).'};
            case 2
                text = {'Variable: fpetbatch.glm.in.data'; ''; '[Mandatory]'; ''; 'Input data for the GLM, normally a 4D NifTI PET image which has been preprocessed.'};
            case 3
                text = {'Variable: fpetbatch.glm.in.framelength'; ''; '[Mandatory]'; ''; 'Length of the fPET frames, which is always entered as seconds.'};
            case 4
                text = {'Variable: fpetbatch.glm.in.time'; ''; '[Mandatory]'; ''; 'Flag used to indicate in which unit ALL timings for GLM calculations (e.g., regressor timings, etc.) are entered. Options: Frames/Seconds.'};
        end
    case 2
        switch row
            case 1
                text = {'Variable: fpetbatch.glm.in.mask.bl'; ''; '[Mandatory]'; ''; 'Mask used to define the voxels to include in the GLM estimation.'};
            case 2
                text = {'Variable: fpetbatch.glm.in.mask.th'; 'Optional threshold for the baseline exclusion mask, in case mask is not binary. For multiple values use the comma "," to seperate each threshold.'};
            case 3
                text = {'Variable: fpetbatch.glm.in.mask.bl_excl'; 'Mask(s) used to define the non-Task based baseline.'};
            case 4
                text = {'Variable: fpetbatch.glm.in.bl_type'; 'How the baseline regressor is extracted from the functional image. Options: Mask (default)/3rd order polynomial.'};
            case 5
                text = {'Variable: fpetbatch.glm.in.mask.calc'; 'Mask where calculations are carried out.'};
            case 6
                text = {'Variable: fpetbatch.glm.in.bl_start_fit'; 'Define a startpoint from where the GLM estimation is started. Only needed when 3rd Order Polynomial is selcted as the baseline definition input.'};
        end
    case 3
        switch row
            case 1
                text = {'Variable: fpetbatch.glm.in.fil.apply'; 'Flag used to apply a low-pass filter on the 4D imaging data before being entered into the GLM. Options: true (default)/false.'};
            case 2
                text = {'Variable: fpetbatch.glm.in.fil.order'; 'Low-pass filter order.'};
            case 3
                text = {'Variable: fpetbatch.glm.in.fil.cutoff'; 'Cutoff frequency for low-pass filter given in seconds or frames.'};
            case 4
                text = {'Variable: fpetbatch.glm.in.regr_motion'; 'Motion nuisance regressors from the SPM realignment step. Input is a .txt or .mat file'};
            case 5
                text = {'Variable: fpetbatch.glm.in.regr_motion_pca'; 'Flag used to apply a PCA on the motion regressors to reduce dimentionality. Options: true (default)/false.'};
            case 6
                text = {'Variable: fpetbatch.glm.in.regr_add'; 'Additional nuisance regression parameters, for example CSF or WM signal. Input is a .txt or .mat file'};
        end
    case 4
        switch row
            case 1
                text = {'Variable: fpetbatch.glm.in.regr'; 'Option to add task-induced regressors to the GLM, Input: name, onset(s) and end(s) of each task of interest. For multiple start or end points, use a comma "," to seperate each input.'};
            case 2
                text = 'Option to copy a previously existing task regressor.';
            case 3
                text = 'Option to remove preexisting task regressors';
        end
    case 5
        switch row
            case 1
                text = {'Variable: fpetbatch.run_psc'; ''; '[Mandatory]'; ''; 'Flag to estimate percent signal change for all task regressors. Options: true/false (default).'};
            case 2
                text = {'Variable: fpetbatch.run_quant'; ''; '[Mandatory]'; ''; 'Flag to quantify all the task regerssors and baseline. Options: true/false (default).'};
            case 3
                text = {'Variable: fpetbatch.quant.in.time'; ''; '[Mandatory]'; ''; 'Flag used to indicate in which unit ALL timings for quantification are entered. Options: Seconds/Minutes.'};
            case 4
                text = {'Variable: fpetbatch.quant.in.wb'; 'Path and file name for the whole-blood file.'};
            case 5
                text = {'Variable: fpetbatch.quant.in.plasma' 'Path and file name for the blood plasma file'};
            case 6
                text = {'Variable: fpetbatch.quant.in.pwbr'; 'Path and file name for the plasma/whole-blood file for estimation.'};
            case 7
                text = {'Variable: fpetbatch.quant.in.parent'; 'Path and file name for the parent fraction.'};
            case 8
                text = {'Variable: fpetbatch.quant.in.pwbr_fit'; 'Fit Method for Plasma/Whole-Blood Ratio. Options: Average (default)/Linear fit'};
            case 9
                text = {'Variable: fpetbatch.quant.in.lc'; 'Input lumped constant for quantification. Default: 0.89.'};
            case 10
                text = {'Variable: fpetbatch.quant.in.vb'; 'Input for fractional whole-blood volume. Default: 0.05.'};
            case 11
                text = {'Variable: fpetbatch.quant.in.bloodlvl'; 'Input for participants blood glucose level.'};
            case 12
                text = {'Variable: fpetbatch.quant.in.tstar'; 'Input T*, which is the time to start fit of Patlak plot, given as fraction of full scan duration. Default=1/3 of scan duration'};
        end
    case 6
        switch row
            case 1
                text = {'Variable: fpetbatch.glm.in.regr_motion_incomplete'; 'Correct incomplete motion nuisance regressors by adding initial or final zeros. Options: At the beginning/end'};
            case 2
                text = {'Variable: fpetbatch.glm.in.regr_orth'; 'Orthogonalization of task regressors vs baseline. Options: true (default)/false.'};
            case 3
                text = {'Variable: fpetbatch.glm.in.weight'; 'Weight GLM timepoints. Input: vector of weights.'};
            case 4
                text = {'Variable: fpetbatch.glm.in.rem_start'; 'Number of initial frames (or seconds) to be removed from data and regressors (after potentially adding zeros)'};
            case 5
                text = {'Variable: fpetbatch.glm.in.rem_end'; 'Number of final frames (or seconds) to be removed from data and regressors (after potentially adding zeros)'};
            case 6
                text = {'Variable: fpetbatch.glm.in.data_incomplete.flag'; 'Adds an anchor point (0kBq at t=0min) if pet acquisition started after radioligand application (and weight this point in glm higher)'};
            case 7
                text = {'Variable: fpetbatch.glm.in.data_incomplete.start'; 'Start times of missing data (frames or seconds)'};
            case 8
                text = {'Variable: fpetbatch.glm.in.data_incomplete.end'; 'End times of missing data (frames or seconds)'};
        end
    case 7
        switch row
            case 1
                text = {'Variable: fpetbatch.run_tacplot'; ''; '[Mandatory]'; ''; 'Flag to run the TAC plot. Options: true/false (default).'};
            case 2
                text = {'Variable: fpetbatch.tacplot.in.regr'; ''; '[Mandatory]'; ''; 'Number of regressor(s) to be plotted, sarting with the cummulation of 1=constant, 2=baseline, 3=task regressor #1, etc.'};
            case 3
                text = {'Variable: fpetbatch.tacplot.in.dir'; ''; '[Mandatory]'; ''; 'fPET.mat files of each participant to be plotted.'};
            case 4
                text = {'Variable: fpetbatch.tacplot.in.mask'; ''; '[Mandatory]'; ''; 'Path and/or filename of mask used to extract the TAC of interest'};
            case 5
                text = {'Variable: fpetbatch.tacplot.in.indiv'; 'Flag to plot the individual TAC. Options: true/false (default).'};
            case 6
                text = {'Variable: fpetbatch.tacplot.in.average'; 'Flag to plot the average TAC. Options: true (default)/false.'};
            case 7
                text = {'Variable: fpetbatch.tacplot.in.raw'; 'Flag to plot the raw TAC. Options: true/false (default).'};
        end
    case 8 % Connectivity
        switch row
            case 1
                text = {'Variable: fpetbatch.run_conn'; ''; '[Mandatory]'; ''; 'Flag to estimate metabolic connectivity. Options: true/false (default).'};
            case 2
                text = {'Variable: fpetbatch.conn.in.data'; ''; '[Mandatory]'; ''; 'Input file(s) for the connectivity estimation.'};
            case 3
                text = {'Variable: fpetbatch.conn.in.type'; 'Technique used to remove the tracer baseline uptake. Options: Mask/3rd order polynomial detrending (Global and per ROI).'};
            case 4
                text = {'Variable: fpetbatch.conn.in.bl_start_fit'; 'Starting point for baseline removal used for both 3rd order polynomial detrending options.'};
            case 5
                text = {'Variable: fpetbatch.conn.in.atlas'; 'Atlas used to estimate the connectivity matrices.'};
          %  case 6
          %      text = {'Variable: fpetbatch.conn.in.fil.order'; 'If band-pass filter is selected. Input filter order.'};
          %  case 7
          %      text = {'Variable: fpetbatch.conn.in.fil.cutoff'; 'If band-pass filter is selected. Input cut-off frquency.'};
            case 6
                text = {'Variable: fpetbatch.conn.in.regr_motion'; 'Input nuisance motion regressors file'};
            case 7
                text = {'Variable: fpetbatch.conn.in.regr_motion_pca'; 'Flag to apply PCA dimentionality reduction to the nuisance regressors. Options: true (default)/false.'};
            case 8
                text = {'Variable: fpetbatch.conn.in.regr_add'; 'Input of additional nuisance regressors to compute'};
            case 9
                text = {'Variable: fpetbatch.conn.in.mask_bl'; ''; '[Mandatory for third-order polynomial]'; ''; 'Mask used to define the baseline, which in turn is used to detrend the input data.'};
            case 10
                text = {'Variable: fpetbatch.conn.in.framelength'; ''; '[Mandatory]'; ''; 'Frame length (TR) of the input data in seconds.'};
            case 11
                text = {'Variable: fpetbatch.conn.in.time'; '[Mandatory]'; ''; 'Tempral unit of input data. Options: (Frames/Seconds)'};
            case 12
                text = {'Variable: fpetbatch.conn.in.mask_wm'; '[Mandatory]'; 'Mask used for white matter nuisance regressor extraction (CompCor filter only)'};
            case 13
                text = {'Variable: fpetbatch.conn.in.mask_csf'; '[Mandatory]'; 'Mask used for cerebrospinal fluid nuisance regressor extraction (CompCor filter only)'};
        end
    case 9
        switch row
            case 1
                text = {'Variable: fpetbatch.conn.in.rem_start'; 'Remove intital frames from metaboolic connectivity estimation.'};
            case 2
                text = {'Variable: fpetbatch.conn.in.rem_end'; 'Remove final frames from metaboolic connectivity estimation.'};
            case 3
                text = {'Variable: fpetbatch.conn.in.regr_motion_incomplete'; 'Correct incomplete motion nuisance regressors by adding initial or final zeros. Options: At the beginning/end'};
            case 4
                text = {'Variable: fpetbatch.conn.in.data_norm'; ''; 'Input file for the extraction of tissue nuisance extraction (CompCor filter only)'};
            case 5
                text = {'Variable: fpetbatch.conn.in.nui_t'; ''; 'Tissue nuisance regressor mask threshold (CompCor filter only)'};
            case 6
                text = {'Variable: fpetbatch.conn.in.mask_calc'; ''; 'Mask used to constrain connectivity estimation (CompCor filter only)'};
            case 7
                text = {'Variable: fpetbatch.conn.in.fil.cutoff'; ''; 'Bandpass cutoff frequencies if required. Inputted in sec or frames. Set to -1 to disable (CompCor filter only)'};
            case 8
                text = {'Variable: fpetbatch.conn.in.fil.sig_t'; ''; 'Temporal sigma value for spatio-temporal filter'};
            case 9
                text = {'Variable: fpetbatch.conn.in.fil.sig_s' ''; 'Spatial sigma value for spatio-temporal filter'};
        end
    case 10
        switch row
            case 1
                text = {'Variable: fpetbatch.run_cov'; ''; '[Mandatory]'; ''; 'Flag to estimate metabolic covariance. Options: true/false (default).'};
            case 2
                text = {'Variable: fpetbatch.cov.in.data'; ''; '[Mandatory]'; ''; 'Input file(s) for the covariance estimation.'};
            case 3
                text = {'Variable: fpetbatch.cov.in.atlas'; ''; '[Mandatory]'; ''; 'Atlas used to estimate the covariance matrices.'};
            case 4
                text = {'Variable: fpetbatch.cov.in.mask_norm'; ''; '[Mandatory]'; ''; 'Mask to normalize the data. Usually a gray matter mask'};
            case 5
                text = {'Variable: fpetbatch.cov.in.regr_add'; ''; 'Input of additional nuisance regressors to compute'};
            case 6
                text = {'Variable: fpetbatch.cov.in.jk'; ''; 'Run Jackknife leave-one-out covariance estimation'};
            case 7
                text = {'Variable: fpetbatch.cov.in.pca'; ''; 'Run PCA decomposition of covariance'};
            case 8
                text = {'Variable: fpetbatch.cov.in.pc'; ''; 'Number of principle components to be estimtated'};
            case 9
                text = {'Variable: fpetbatch.cov.in.ica'; ''; 'Run ICA decomposition of covariance'};
            case 10 
                text = {'Variable: fpetbatch.cov.in.ic'; ''; 'Number of independent components to be estimtated'};
        end
    case 11
        switch row
            case 1
                text = {'Variable: fpetbatch.run_ica'; ''; '[Mandatory]'; ''; 'Flag to run the ICA estimation. Options: true/false (default).'};
            case 2
                text = {'Variable: fpetbatch.ica.in.data'; ''; '[Mandatory]'; ''; 'Input file(s) for the ICA estimation.'};
            case 3
                text = {'Variable: fpetbatch.ica.in.pca'; 'Flag to perform PCA dimentionality reduction of the input data. Options: true (default)/false'};
            case 4
                text = {'Variable: fpetbatch.ica.in.pc'; 'Number of principle components to reduce the input data to. Default: 40.'};
            case 5
                text = {'Variable: fpetbatch.ica.in.ic'; 'Number of independent components to estimate. Default: 20.'};
            case 6
                text = {'Variable: fpetbatch.ica.in.rem_start'; 'Remove intital frames from ICA input.'};
            case 7 
                text = {'Variable: fpetbatch.ica.in.rem_end'; 'Remove final frames from ICA input.'};
            case 8
                text = {'Variable: fpetbatch.ica.in.framelength'; 'Length of the fPET frames, which is always entered as seconds.'};
            case 9
                text = {'Variable: fpetbatch.ica.in.time'; 'Flag used to indicate in which unit ALL timings for the ICA are entered. Options: Frames (default)/Seconds.'};
            case 10
                text = {'Variable: fpetbatch.ica.in.mask.calc'; ''; '[Mandatory]'; ''; 'Mask where calculations are carried out.'};        
        end
    case 13 %% General Settings
        switch row
            case 1
                text = {'Variable: fpetbatch.dir.result'; 'Filepath for where the estimated data is written.'};
            case 2
                text = {'Variable: fpetbatch.overwrite'; 'Flag used to auto overwrite previously estimated GLMs (default: false).'};
        end
end
end