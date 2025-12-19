function error_flag = fpet_tlbx_check_exist(fpetbatch);
% fpet toolbox: check existing data
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria

error_flag = 0;
overwrite_flag = 0;
exist_flag = zeros(1,7);

if isfield(fpetbatch,'dir') && isfield(fpetbatch.dir,'result') && ~isempty(fpetbatch.dir.result)
    if ~exist(fpetbatch.dir.result, 'dir')
        mkdir(fpetbatch.dir.result);
    end
else
	fpetbatch.dir.result = pwd;
end

% glm
if isfield(fpetbatch,'run_glm') && (fpetbatch.run_glm == 1)
    pnfn = fullfile(fpetbatch.dir.result, 'fPET_glm.mat');
    if exist(pnfn, 'file')
        load(pnfn);
        if isfield(fPET,'glm') && isfield(fPET.glm,'complete') && (fPET.glm.complete == 1)
            disp('GLM results already exist.')
            exist_flag(1) = 1;
        end
    end
end
% psc
if isfield(fpetbatch,'run_psc') && (fpetbatch.run_psc == 1)
    pnfn = fullfile(fpetbatch.dir.result, 'fPET_glm.mat');
    if exist(pnfn, 'file')
        load(pnfn);
        if isfield(fPET,'psc') && isfield(fPET.psc,'complete') && (fPET.psc.complete == 1)
            disp('PSC results already exist.')
            exist_flag(2) = 1;
        end
    end
end
% quant
if isfield(fpetbatch,'run_quant') && (fpetbatch.run_quant == 1)
    pnfn = fullfile(fpetbatch.dir.result, 'fPET_glm.mat');
    if exist(pnfn, 'file')
        load(pnfn);
        if isfield(fPET,'quant') && isfield(fPET.quant,'complete') && (fPET.quant.complete == 1)
            disp('Quantification results already exist.')
            exist_flag(3) = 1;
        end
    end
end
% tacplot -> no check required
% ica
if isfield(fpetbatch,'run_ica') && (fpetbatch.run_ica == 1)
    pnfn = fullfile(fpetbatch.dir.result, 'fPET_ica.mat');
    if exist(pnfn, 'file')
        load(pnfn);
        if isfield(fPET,'ica') && isfield(fPET.ica,'complete') && (fPET.ica.complete == 1)
            disp('ICA results already exist.')
            exist_flag(5) = 1;
        end
    end
end
% conn
if isfield(fpetbatch,'run_conn') && (fpetbatch.run_conn == 1)
    pnfn = fullfile(fpetbatch.dir.result, 'fPET_conn.mat');
    if exist(pnfn, 'file')
        load(pnfn);
        if isfield(fPET,'conn') && isfield(fPET.conn,'complete') && (fPET.conn.complete == 1)
            disp('Connectivity results already exist.')
            exist_flag(6) = 1;
        end
    end
end
% cov
if isfield(fpetbatch,'run_cov') && (fpetbatch.run_cov == 1)
    pnfn = fullfile(fpetbatch.dir.result, 'fPET_cov.mat');
    if exist(pnfn, 'file')
        load(pnfn);
        if isfield(fPET,'cov') && isfield(fPET.cov,'complete') && (fPET.cov.complete == 1)
            disp('Covariance results already exist.')
            exist_flag(7) = 1;
        end
    end
end

% user input to overwrite
if ~isfield(fpetbatch,'overwrite') || (fpetbatch.overwrite == 0)
    if any(exist_flag)
        overwrite_flag = input('Overwrite existing data? 0=no, 1=yes: ');
        if overwrite_flag == 0
            error_flag = 1;
            disp('please chose another results directory or enable to overwrite data.');
            return;
        end
    end
end

% delete existing data
if (overwrite_flag == 1) || (isfield(fpetbatch,'overwrite') && (fpetbatch.overwrite == 1))
    disp('overwriting data.')
    % glm
    if exist_flag(1) == 1
        pnfn = fullfile(fpetbatch.dir.result, 'fPET_glm.mat');
        load(pnfn);
        for ind = 1:numel(fPET.glm.X.name)
            pnfn = fullfile(fPET.dir.result, sprintf('b%i_%s.nii', ind, fPET.glm.X.name{ind}));
            delete(pnfn);
            pnfn = fullfile(fPET.dir.result, sprintf('b%i_%s_PSC.nii', ind, fPET.glm.X.name{ind}));
            if exist(pnfn,'file')
                delete(pnfn);
                exist_flag(2) = 0;
            end
            pnfn = fullfile(fPET.dir.result, sprintf('b%i_%s_Ki.nii', ind, fPET.glm.X.name{ind}));
            if exist(pnfn,'file')
                delete(pnfn);
                exist_flag(3) = 0;
            end
            pnfn = fullfile(fPET.dir.result, sprintf('b%i_%s_CMRGlu.nii', ind, fPET.glm.X.name{ind}));
            if exist(pnfn,'file')
                delete(pnfn);
            end
            pnfn = fullfile(fPET.dir.result, sprintf('t%i_%s.nii', ind, fPET.glm.X.name{ind}));
            delete(pnfn);
        end
        pnfn = fullfile(fPET.dir.result, 'residuals.nii');
        delete(pnfn);
    end
    % psc
    if exist_flag(2) == 1
        pnfn = fullfile(fpetbatch.dir.result, 'fPET_glm.mat');
        load(pnfn);
        nr_regr_stim = size(fPET.glm.X.stim.d,2);
        for ind = 1:nr_regr_stim
            pnfn = fullfile(fPET.dir.result, sprintf('b%i_%s_PSC.nii', ind+2, fPET.glm.X.name{ind+2}));
            delete(pnfn);
        end
    end
    % quant
    if exist_flag(3) == 1
        pnfn = fullfile(fpetbatch.dir.result, 'fPET_glm.mat');
        load(pnfn);
        nr_regr_stim = size(fPET.glm.X.stim.d,2);
        for ind = 1:nr_regr_stim+1
            pnfn = fullfile(fPET.dir.result, sprintf('b%i_%s_Ki.nii', ind+1, fPET.glm.X.name{ind+1}));
            delete(pnfn);
            pnfn = fullfile(fPET.dir.result, sprintf('b%i_%s_CMRGlu.nii', ind+1, fPET.glm.X.name{ind+1}));
            if exist(pnfn,'file')
                delete(pnfn);
            end
        end
    end
    % tacplot -> no action required
    if exist_flag(4) == 1
    end
    % ica
    if exist_flag(5) == 1
        pnfn = fullfile(fpetbatch.dir.result, 'fPET_ica.mat');
        load(pnfn);
        if numel(fPET.ica.files) > 1
            prefix = 'gic';
        else
            prefix = 'ic';
        end
        for ind = 1:fpetbatch.ica.in.ic
            pnfn = fullfile(fPET.dir.result, sprintf('%s%i.nii', prefix, ind));
            delete(pnfn);
        end
    end
    % conn
    if exist_flag(6) == 1
        pnfn = fullfile(fpetbatch.dir.result, 'fPET_conn.mat');
        load(pnfn);
		R.name{1} = 'cMC_bl1';
		R.name{2} = 'cMC_bl2';
		R.name{3} = 'cMC_bl3';
		R.name{4} = 'cMC_st';
		R.name{5} = 'cMC_cc';
		R.name{6} = 'cMC_bn';
		R.name{7} = 'eMC';
        pnfn = fullfile(fPET.dir.result, sprintf('Conn_%s.mat', R.name{fPET.conn.type}));
        delete(pnfn);
    end
    % cov
    if exist_flag(7) == 1
        pnfn = fullfile(fpetbatch.dir.result, 'fPET_cov.mat');
        load(pnfn);
        pnfn = fullfile(fPET.dir.result, sprintf('Cov_n%i.mat', numel(fPET.Y.h)));
        delete(pnfn);
    end
end


end

