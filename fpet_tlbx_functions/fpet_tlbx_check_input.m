function error_flag = fpet_tlbx_check_input(fpetbatch, batchtype);
% fpet toolbox: check input data
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria

error_flag = 0;

% glm
if batchtype == 1
    nr_err_glm = 0;
    disp('*****')
    disp('checking input data for general linear model.')
    
    % mandatory
    if ~isfield(fpetbatch.glm.in,'data') || isempty(fpetbatch.glm.in.data)
        disp('fPET input data is not defined.');
        nr_err_glm = nr_err_glm + 1;
    else
        Y.h = spm_vol(fpetbatch.glm.in.data);
        if ~numel(Y.h) >= 5
            disp('fPET input has less than 5 time points, glm not feasible.');
            nr_err_glm = nr_err_glm + 1;
        end
    end

    if ~isfield(fpetbatch.glm.in,'framelength') || isempty(fpetbatch.glm.in.framelength)
        disp('frame length of fPET data is not defined.');
        nr_err_glm = nr_err_glm + 1;
    end

    if ~isfield(fpetbatch.glm.in.mask,'bl') || isempty(fpetbatch.glm.in.mask.bl)
        disp('mask for baseline definition is not defined.');
        nr_err_glm = nr_err_glm + 1;
    else
        M.bl.h = spm_vol(fpetbatch.glm.in.mask.bl);
        if ~isequal(Y.h(1).dim(1:3), M.bl.h.dim)
            disp('spatial dimensions of baseline mask do not match input data.');
            nr_err_glm = nr_err_glm + 1;
        end
    end
    
    if ~isfield(fpetbatch.glm.in,'time') || isempty(fpetbatch.glm.in.time)
        disp('timing for glm (seconds=1 or frames=2) not defined.');
        nr_err_glm = nr_err_glm + 1;
    else
        if ~any(fpetbatch.glm.in.time==[1 2])
            disp('definition of timing for glm is unknown, should be 1=seconds or 2=frames.');
            nr_err_glm = nr_err_glm + 1;
        end
    end

    
    % optional
    if ~isfield(fpetbatch.glm.in,'regr') || isempty(fpetbatch.glm.in.regr)
        disp('warning: stimulation regressor not defined.');
    else
        for ind = 1:numel(fpetbatch.glm.in.regr)
            if ~isfield(fpetbatch.glm.in.regr(ind),'start')
                fprintf('start of stimulation regressor %i not defined.\n', ind);
                nr_err_glm = nr_err_glm + 1;
            else
                if ~isnumeric(fpetbatch.glm.in.regr(ind).start)
                    fprintf('start of stimulation regressor %i is not a number.\n', ind);
                    nr_err_glm = nr_err_glm + 1;
                end
            end
            if ~isfield(fpetbatch.glm.in.regr(ind),'end')
                fprintf('end of stimulation regressor %i not defined.\n', ind);
                nr_err_glm = nr_err_glm + 1;
            else
                if ~isnumeric(fpetbatch.glm.in.regr(ind).end)
                    fprintf('end of stimulation regressor %i is not a number.\n', ind);
                    nr_err_glm = nr_err_glm + 1;
                else
                    if numel(fpetbatch.glm.in.regr(ind).start) ~= numel(fpetbatch.glm.in.regr(ind).end)
                        fprintf('number of start values does not match number of end values for stimulation regressor %i.\n', ind);
                        nr_err_glm = nr_err_glm + 1;
                    end
                end
            end
        end
    end
    
    if isfield(fpetbatch.glm.in.mask,'calc') && ~isempty(fpetbatch.glm.in.mask.calc)
        M.calc.h = spm_vol(fpetbatch.glm.in.mask.calc);
        if ~isequal(Y.h(1).dim(1:3), M.calc.h.dim)
            disp('spatial dimensions of calculation mask do not match input data.');
            nr_err_glm = nr_err_glm + 1;
        end
    end
    
    if isfield(fpetbatch.glm.in.mask,'bl_excl') && ~isempty(fpetbatch.glm.in.mask.bl_excl)
        nr_m_blex = numel(fpetbatch.glm.in.mask.bl_excl);
        for ind = 1:nr_m_blex
            M.blex.h = spm_vol(fpetbatch.glm.in.mask.bl_excl{ind});
            if ~isequal(Y.h(1).dim(1:3), M.blex.h.dim)
                fprintf('spatial dimensions of baseline exclusion %i mask does not match input data.', ind);
                nr_err_glm = nr_err_glm + 1;
            end
        end
    end
    
    if isfield(fpetbatch.glm.in.mask,'th') && ~isempty(fpetbatch.glm.in.mask.th)
        if numel(fpetbatch.glm.in.mask.th) ~= nr_m_blex
            disp('number of thresholds for baseline exclusion mask does not match number of masks.')
            nr_err_glm = nr_err_glm + 1;
        end
    end
    
    if isfield(fpetbatch.glm.in,'regr_motion') && ~isempty(fpetbatch.glm.in.regr_motion)
        X.motion.h = fpetbatch.glm.in.regr_motion;
        X.motion.d = importdata(X.motion.h);
        if numel(size(X.motion.d)) ~= 2
            fprintf('motion regressors are not a 2D matrix.')
            nr_err_glm = nr_err_glm + 1;
        else
            if ~((size(X.motion.d,1) == numel(Y.h)) || (size(X.motion.d,2) == numel(Y.h)))
                if ~isfield(fpetbatch.glm.in,'regr_motion_incomplete') || isempty(fpetbatch.glm.in.regr_motion_incomplete)
                    fprintf('temporal dimension of motion regressors does not match input data and zero padding is not enabled.')
                    nr_err_glm = nr_err_glm + 1;
                else
                    if ~any(fpetbatch.glm.in.regr_motion_incomplete==[1 2])
                        disp('WARNING: flag for zero padding of motion regressor should be 1 or 2, other inputs are not considered.')
                    end
                end
            end
        end
    end
    
    if isfield(fpetbatch.glm.in,'regr_add') && ~isempty(fpetbatch.glm.in.regr_add)
        X.add.h = fpetbatch.glm.in.regr_add;
        X.add.d = importdata(X.add.h);
        if numel(size(X.add.d)) ~= 2
            fprintf('additional regressors are not a 2D matrix.')
            nr_err_glm = nr_err_glm + 1;
        else
            if ~((size(X.add.d,1) == Y.h.dim(4)) || (size(X.add.d,2) == Y.h.dim(4)))
                fprintf('temporal dimension of additional regressors does not match input data.')
                nr_err_glm = nr_err_glm + 1;
            end
        end
    end
    
    if isfield(fpetbatch.glm.in,'weight') && ~isempty(fpetbatch.glm.in.weight)
        if ~(numel(fpetbatch.glm.in.weight) == numel(Y.h))
            fprintf('temporal dimension of weights does not match input data.')
            nr_err_glm = nr_err_glm + 1;
        end
    end
    
    if isfield(fpetbatch.glm.in,'bl_type') && ~isempty(fpetbatch.glm.in.bl_type) && (fpetbatch.glm.in.bl_type == 2) 
        if ~isfield(fpetbatch.glm.in,'bl_start_fit') || isempty(fpetbatch.glm.in.bl_start_fit)
            disp('baseline fit defined as 3rd order polynommial but start time not defined.')
            nr_err_glm = nr_err_glm + 1;
        end
    end
    
    if isfield(fpetbatch.glm.in,'fil') && isfield(fpetbatch.glm.in.fil,'apply') && ~isempty(fpetbatch.glm.in.fil.apply) && (fpetbatch.glm.in.fil.apply ~= 0)
        if ~any(fpetbatch.glm.in.fil.apply==[1])
            disp('WARNING: unknown filter type selected, default filter will be applied.')
        end
    end
    
    if isfield(fpetbatch.glm.in,'data_incomplete')
        if isfield(fpetbatch.glm.in.data_incomplete,'flag') && ~isempty(fpetbatch.glm.in.data_incomplete.flag) && (fpetbatch.glm.in.data_incomplete.flag == 1)
            if ~isfield(fpetbatch.glm.in.data_incomplete,'start') || isempty(fpetbatch.glm.in.data_incomplete.start)
                disp('data incomplete flag is activated, but no start time provided.')
                nr_err_glm = nr_err_glm + 1;
            end
            if ~isfield(fpetbatch.glm.in.data_incomplete,'end') || isempty(fpetbatch.glm.in.data_incomplete.end)
                disp('data incomplete flag is activated, but no end time provided.')
                nr_err_glm = nr_err_glm + 1;
            end
            if numel(fpetbatch.glm.in.data_incomplete.start) ~= numel(fpetbatch.glm.in.data_incomplete.end)
                disp('number of start values does not match number of end values for incomplete data.')
                nr_err_glm = nr_err_glm + 1;
            end
        end
    end

    if nr_err_glm > 0
        disp('*****')
        fprintf('\nfound %i errors for glm definition.\n', nr_err_glm)
        disp('please fix errors and run fpet_tlbx again.')
        error_flag = 1;
        return
    else
        disp('input data for general linear model ok.')
    end
    
% percent signal change
elseif batchtype == 2
    nr_err_psc = 0;
    disp('*****')
    disp('checking input data for calculation of percent signal change.')
    
    % fPET.mat available
    if ~(isfield(fpetbatch,'dir') && isfield(fpetbatch.dir,'result') && ~isempty(fpetbatch.dir.result))
        fpetbatch.dir.result = pwd;
    end
    pnfn = fullfile(fpetbatch.dir.result,'fPET_glm.mat');
    if ~exist(pnfn, 'file')
        disp('fPET_glm.mat not found.')
        nr_err_psc = nr_err_psc + 1;
    else
        load(pnfn);
        
        % glm complete
        if ~isfield(fPET.glm,'complete') || (fPET.glm.complete ~= 1)
            disp('glm estimation not successfully completed.')
            nr_err_psc = nr_err_psc + 1;
        end
        % stim regressor defined
        if ~isfield(fPET.glm.X.stim,'d') || isempty(fPET.glm.X.stim.d)
            disp('no stimulation regressor defined in glm estimation.')
            nr_err_psc = nr_err_psc + 1;
        end
    end
    
    if nr_err_psc > 0
        disp('*****')
        fprintf('\nfound %i errors for calculation of percent signal change.\n', nr_err_psc)
        disp('please fix errors and run fpet_tlbx again.')
        error_flag = 1;
        return
    else
        disp('input data for percent signal change ok.')
    end
    clear fPET;

% quantification
elseif batchtype == 3
    nr_err_quant = 0;
    disp('*****')
    disp('checking input data for quantification.')
    
    % fPET.mat available
    if ~(isfield(fpetbatch,'dir') && isfield(fpetbatch.dir,'result') && ~isempty(fpetbatch.dir.result))
        fpetbatch.dir.result = pwd;
    end
    pnfn = fullfile(fpetbatch.dir.result,'fPET_glm.mat');
    if ~exist(pnfn, 'file')
        disp('fPET_glm.mat not found.')
        nr_err_quant = nr_err_quant + 1;
    else
        load(pnfn);

        % glm complete
        if ~isfield(fPET.glm,'complete') || fPET.glm.complete ~= 1
            disp('glm estimation not successfully completed.')
            nr_err_quant = nr_err_quant + 1;
        end
        % stim regressor defined
        if ~isfield(fPET.glm.X.stim,'d') || isempty(fPET.glm.X.stim.d)
            disp('no stimulation regressor defined in glm estimation.')
            nr_err_quant = nr_err_quant + 1;
        end
    end
    
    % time
    if ~isfield(fpetbatch.quant.in,'time') || isempty(fpetbatch.quant.in.time)
        disp('timing for quantification (seconds=1 or minutes=2) not defined.');
        nr_err_quant = nr_err_quant + 1;
    else
        if ~any(fpetbatch.quant.in.time==[1 2])
            disp('definition of timing for quantification is unknown, should be 1=seconds or 2=minutes.');
            nr_err_quant = nr_err_quant + 1;
        end
    end

    % blood data
    if ~isfield(fpetbatch.quant.in,'wb') || isempty(fpetbatch.quant.in.wb)
        if ~isfield(fpetbatch.quant.in,'plasma') || isempty(fpetbatch.quant.in.plasma)
            disp('whole blood and plasma data not defined.')
            nr_err_quant = nr_err_quant + 1;
        end
        if ~isfield(fpetbatch.quant.in,'pwbr') || isempty(fpetbatch.quant.in.pwbr)
            disp('warning: whole blood data and plasma/whole blood ratio not defined, vB is set to 0.')
        end
    else
        if (~isfield(fpetbatch.quant.in,'plasma') || isempty(fpetbatch.quant.in.plasma)) && (~isfield(fpetbatch.quant.in,'pwbr') || isempty(fpetbatch.quant.in.pwbr))
            disp('whole blood data provided, but plasma data or plasma/whole blood ratio missing.')
            nr_err_quant = nr_err_quant + 1;
        end
    end
    
    if ~isfield(fpetbatch.quant.in,'bloodlvl') || isempty(fpetbatch.quant.in.bloodlvl)
        disp('prescan blood level not defined, only net influx constant will be calculated.')
    end
    
    if nr_err_quant > 0
        disp('*****')
        fprintf('found %i errors for quantification.\n', nr_err_quant)
        disp('please fix errors and run fpet_tlbx again.')
        error_flag = 1;
        return
    else
        disp('input data for quantification ok.')
    end

% tac plot
elseif batchtype == 4
    nr_err_tacplot = 0;
    disp('*****')
    disp('checking input data for plotting tacs.')
    
    % glm
    if ~isfield(fpetbatch.tacplot.in,'type') || isempty(fpetbatch.tacplot.in.type) || (fpetbatch.tacplot.in.type == 1)
        % fPET.mat available
        if ~isfield(fpetbatch.tacplot.in,'dir') || isempty(fpetbatch.tacplot.in.dir)
            disp('files with fPET glm results not defined.');
            nr_err_tacplot = nr_err_tacplot + 1;
        else
            nr_subj = numel(fpetbatch.tacplot.in.dir);
            for ind = 1:nr_subj
                pnfn = fpetbatch.tacplot.in.dir{ind};
                if ~exist(pnfn, 'file')
                    disp(pnfn)
                    disp('fPET_glm.mat not found.')
                    nr_err_tacplot = nr_err_tacplot + 1;
                else
                    % glm complete
                    load(pnfn);
                    if ~isfield(fPET.glm,'complete') || (fPET.glm.complete ~= 1)
                        disp(pnfn)
                        disp('glm estimation not successfully completed.')
                        nr_err_tacplot = nr_err_tacplot + 1;
                    end
                end
            end
        end
        % regressor to plot
        if ~isfield(fpetbatch.tacplot.in,'regr') || isempty(fpetbatch.tacplot.in.regr)
            disp('regressor to be plotted is not defined.');
            nr_err_tacplot = nr_err_tacplot + 1;
        end
            
    % ica
    elseif fpetbatch.tacplot.in.type == 2
        % fPET.mat available
        if ~isfield(fpetbatch.tacplot.in,'dir') || isempty(fpetbatch.tacplot.in.dir)
            disp('file with fPET ica results not defined.');
            nr_err_tacplot = nr_err_tacplot + 1;
        else
            if numel(fpetbatch.tacplot.in.dir) ~= 1
                disp('plot for ica expects only one input file.');
                nr_err_tacplot = nr_err_tacplot + 1;
            else
                pnfn = fpetbatch.tacplot.in.dir{1,1};
                if ~exist(pnfn, 'file')
                    disp(pnfn)
                    disp('fPET_ica.mat not found.')
                    nr_err_tacplot = nr_err_tacplot + 1;
                else
                    % ica complete
                    load(pnfn);
                    if ~isfield(fPET.ica,'complete') || fPET.ica.complete ~= 1
                        disp(pnfn)
                        disp('ica estimation not successfully completed.')
                        nr_err_tacplot = nr_err_tacplot + 1;
                    end
                    if ~isfield(fPET,'framelength') && (~isfield(fpetbatch.tacplot.in,'framelength') || isempty(fpetbatch.tacplot.in.framelength))
                        disp('frame length of fPET data is not defined.');
                        nr_err_tacplot = nr_err_tacplot + 1;
                    end
                end
            end
        end
    end
    
    % dimensions of mask
    if ~isfield(fpetbatch.tacplot.in,'mask') || isempty(fpetbatch.tacplot.in.mask)
        disp('mask for tac extraction is not defined.');
        nr_err_tacplot = nr_err_tacplot + 1;
    else
        M.plot.h = spm_vol(fpetbatch.tacplot.in.mask);
        if exist('fPET','var') && isfield(fPET,'Y') && ~isequal(fPET.Y(1).h(1).dim(1:3), M.plot.h.dim)
            disp('spatial dimensions of tac mask do not match input data.');
            nr_err_tacplot = nr_err_tacplot + 1;
        end
    end
    
    if nr_err_tacplot > 0
        disp('*****')
        fprintf('found %i errors for plotting tacs.\n', nr_err_tacplot)
        disp('please fix errors and run fpet_tlbx again.')
        error_flag = 1;
        return
    else
        disp('input data for plotting tacs ok.')
    end

% ica
elseif batchtype == 5
    nr_err_ica = 0;
    disp('*****')
    disp('checking input data for ica.')

    % mandatory
    if ~isfield(fpetbatch.ica.in,'data') || isempty(fpetbatch.ica.in.data)
        disp('fPET input data is not defined.');
        nr_err_ica = nr_err_ica + 1;
    else
        Y.h = spm_vol(fpetbatch.ica.in.data{1});
        if ~numel(Y.h) >= 5
            disp('fPET input has less than 5 time points, ica not feasible.');
            nr_err_ica = nr_err_ica + 1;
        end
    end

    if ~isfield(fpetbatch.ica.in.mask,'calc') || isempty(fpetbatch.ica.in.mask.calc)
        disp('mask for calculations is not defined.');
        nr_err_ica = nr_err_ica + 1;
    else
        M.calc.h = spm_vol(fpetbatch.ica.in.mask.calc);
        if ~isequal(Y.h(1).dim(1:3), M.calc.h.dim)
            disp('spatial dimensions of calculation mask do not match input data.');
            nr_err_ica = nr_err_ica + 1;
        end
    end

    if nr_err_ica > 0
        disp('*****')
        fprintf('found %i errors for ica.\n', nr_err_ica)
        disp('please fix errors and run fpet_tlbx again.')
        error_flag = 1;
        return
    else
        disp('input data for ica ok.')
    end

% conn
elseif batchtype == 6
    nr_err_conn = 0;
    disp('*****')
    disp('checking input data for connectivity.')
    
    % mandatory
    if ~isfield(fpetbatch.conn.in,'data') || isempty(fpetbatch.conn.in.data)
        disp('fPET input data is not defined.');
        nr_err_conn = nr_err_conn + 1;
    else
        Y.h = spm_vol(fpetbatch.conn.in.data);
        if ~numel(Y.h) >= 5
            disp('fPET input has less than 5 time points, connectivity not feasible.');
            nr_err_conn = nr_err_conn + 1;
        end
    end
    
    if ~isfield(fpetbatch.conn.in,'framelength') || isempty(fpetbatch.conn.in.framelength)
        disp('frame length of fPET data is not defined.');
        nr_err_conn = nr_err_conn + 1;
    end
    
    if ~isfield(fpetbatch.conn.in,'time') || isempty(fpetbatch.conn.in.time)
        disp('timing for connectivity (seconds=1 or frames=2) not defined.');
        nr_err_conn = nr_err_conn + 1;
    else
        if ~any(fpetbatch.conn.in.time==[1 2])
            disp('definition of timing for connectivity is unknown, should be 1=seconds or 2=frames.');
            nr_err_conn = nr_err_conn + 1;
        end
    end
    
    if ~isfield(fpetbatch.conn.in,'atlas') || isempty(fpetbatch.conn.in.atlas)
        disp('atlas with brain regions is not defined.');
        nr_err_conn = nr_err_conn + 1;
    else
        M.atlas.h = spm_vol(fpetbatch.conn.in.atlas);
        if ~isequal(Y.h(1).dim(1:3), M.atlas.h.dim)
            disp('spatial dimensions of atlas do not match input data.');
            nr_err_conn = nr_err_conn + 1;
        end
    end
    
    % optional
    if isfield(fpetbatch.conn.in,'regr_motion') && ~isempty(fpetbatch.conn.in.regr_motion)
        X.motion.h = fpetbatch.conn.in.regr_motion;
        X.motion.d = importdata(X.motion.h);
        if numel(size(X.motion.d)) ~= 2
            fprintf('motion regressors are not a 2D matrix.')
            nr_err_conn = nr_err_conn + 1;
        else
            if ~((size(X.motion.d,1) == numel(Y.h)) || (size(X.motion.d,2) == numel(Y.h)))
                if ~isfield(fpetbatch.conn.in,'regr_motion_incomplete') || isempty(fpetbatch.conn.in.regr_motion_incomplete)
                    fprintf('temporal dimension of motion regressors does not match input data and zero padding is not enabled.')
                    nr_err_conn = nr_err_conn + 1;
                else
                    if ~any(fpetbatch.conn.in.regr_motion_incomplete==[1 2])
                        disp('WARNING: flag for zero padding of motion regressor should be 1 or 2, other inputs are not considered.')
                    end
                end
            end
        end
    end
    
    if isfield(fpetbatch.conn.in,'regr_add') && ~isempty(fpetbatch.conn.in.regr_add)
        X.add.h = fpetbatch.conn.in.regr_add;
        X.add.d = importdata(X.add.h);
        if numel(size(X.add.d)) ~= 2
            fprintf('additional regressors are not a 2D matrix.')
            nr_err_conn = nr_err_conn + 1;
        else
            if ~((size(X.add.d,1) == Y.h.dim(4)) || (size(X.add.d,2) == Y.h.dim(4)))
                fprintf('temporal dimension of additional regressors does not match input data.')
                nr_err_conn = nr_err_conn + 1;
            end
        end
    end
    
    if isfield(fpetbatch.conn.in,'bl_type') && ~isempty(fpetbatch.conn.in.bl_type)
        if fpetbatch.conn.in.bl_type == 1 || fpetbatch.conn.in.bl_type == 2
            if ~isfield(fpetbatch.conn.in,'mask_bl') || isempty(fpetbatch.conn.in.mask_bl)
                disp('mask for baseline definition is not defined.');
                nr_err_conn = nr_err_conn + 1;
            else
                M.bl.h = spm_vol(fpetbatch.conn.in.mask_bl);
                if ~isequal(Y.h(1).dim(1:3), M.bl.h.dim)
                    disp('spatial dimensions of baseline mask do not match input data.');
                    nr_err_conn = nr_err_conn + 1;
                end
            end
        end
        if fpetbatch.conn.in.bl_type == 2 || fpetbatch.conn.in.bl_type == 3
            if ~isfield(fpetbatch.conn.in,'bl_start_fit') || isempty(fpetbatch.conn.in.bl_start_fit)
                disp('baseline fit defined as 3rd order polynommial but start time not defined.')
                nr_err_conn = nr_err_conn + 1;
            end
        end
    end
    
    if nr_err_conn > 0
        disp('*****')
        fprintf('found %i errors for connectivity.\n', nr_err_conn)
        disp('please fix errors and run fpet_tlbx again.')
        error_flag = 1;
        return
    else
        disp('input data for connectivity ok.')
    end

% cov
elseif batchtype == 7
    nr_err_cov = 0;
    disp('*****')
    disp('checking input data for covariance.')
    
    % mandatory
    if ~isfield(fpetbatch.cov.in,'data') || isempty(fpetbatch.cov.in.data)
        disp('fPET input data is not defined.');
        nr_err_cov = nr_err_cov + 1;
    else
        Y.h = spm_vol(fpetbatch.cov.in.data);
        if ~numel(Y.h) >= 5
            disp('fPET input has less than 5 subjects, covariance not feasible.');
            nr_err_cov = nr_err_cov + 1;
        end
    end
    
    if ~isfield(fpetbatch.cov.in,'atlas') || isempty(fpetbatch.cov.in.atlas)
        disp('atlas with brain regions is not defined.');
        nr_err_cov = nr_err_cov + 1;
    else
        M.atlas.h = spm_vol(fpetbatch.cov.in.atlas);
        if ~isequal(Y.h{1}.dim(1:3), M.atlas.h.dim)
            disp('spatial dimensions of atlas do not match input data.');
            nr_err_cov = nr_err_cov + 1;
        end
    end
    
    % optional
    if isfield(fpetbatch.cov.in,'mask_norm') && ~isempty(fpetbatch.cov.in.mask_norm)
        M.norm.h = spm_vol(fpetbatch.cov.in.mask_norm);
        if ~isequal(Y.h{1}.dim(1:3), M.norm.h.dim)
            disp('spatial dimensions of normalization mask do not match input data.');
            nr_err_cov = nr_err_cov + 1;
        end
    end

    if isfield(fpetbatch.cov.in,'regr_add') && ~isempty(fpetbatch.cov.in.regr_add)
        X.add.h = fpetbatch.cov.in.regr_add;
        X.add.d = importdata(X.add.h);
        if numel(size(X.add.d)) ~= 2
            fprintf('additional regressors are not a 2D matrix.')
            nr_err_cov = nr_err_cov + 1;
        else
            if ~((size(X.add.d,1) == numel(Y.h)) || (size(X.add.d,2) == numel(Y.h)))
                fprintf('temporal dimension of additional regressors does not match input data.')
                nr_err_cov = nr_err_cov + 1;
            end
        end
    end
    
    if nr_err_cov > 0
        disp('*****')
        fprintf('found %i errors for covariance.\n', nr_err_cov)
        disp('please fix errors and run fpet_tlbx again.')
        error_flag = 1;
        return
    else
        disp('input data for covariance ok.')
    end
    
end


end


