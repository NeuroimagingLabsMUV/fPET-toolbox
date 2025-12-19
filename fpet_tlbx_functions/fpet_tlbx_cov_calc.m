function fpet_tlbx_cov_calc(pn)
% fPET toolbox: covariance calculations
%
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria

load(fullfile(pn,'fPET_cov.mat'));

% load data
Y.d = spm_read_vols(fPET.Y.h);
Y.d(isinf(Y.d)) = NaN;

% intensity normalization
nr_roi = nonzeros(unique(fPET.cov.M.atlas.d));
R.roi = zeros(size(Y.d,4),numel(nr_roi));
for ind = 1:size(Y.d,4)
    d_temp = Y.d(:,:,:,ind);
    if ~isempty(fPET.cov.M.norm.d)
        norm_val = mean(d_temp(fPET.cov.M.norm.d==1), 'omitnan');
        d_temp = d_temp/norm_val;
    end
    % extract roi values
    for ind_r = 1:numel(nr_roi)
        R.roi(ind,ind_r) = mean(d_temp(fPET.cov.M.atlas.d==nr_roi(ind_r)));
    end
end

% calculate covariance matrix
if isempty(fPET.cov.X.add.d)
    r = corr(R.roi, 'rows','complete');
else
    r = partialcorr(R.roi, fPET.cov.X.add.d, 'rows','complete');
end
z = 0.5 * log((1+r)./(1-r));

% save data
save(fullfile(fPET.dir.result, sprintf('Cov_n%i.mat', size(Y.d,4))), 'z');

% optional ICA decomposition
if fPET.cov.in.ica == true
    if ~isfield(fPET.cov.in,'ic') || isempty(fPET.cov.in.ic)
        fPET.cov.in.ic = size(R.roi,1);
    end
    R.roi_cent = R.roi - mean(R.roi,1);
    [weights, components, ~] = fastica(R.roi_cent', 'numOfIC', fPET.cov.in.ic, 'approach', 'symm', 'g', 'gauss', 'initGuess', eye(fPET.cov.in.ic));
    save(fullfile(fPET.dir.result, sprintf('Cov_ICA_n%i.mat', size(Y.d,4))), 'components', 'weights');
    disp('ICA decomposition complete.')
end

% optional PCA decomposition
if fPET.cov.in.pca == true
    if ~isfield(fPET.cov.in,'pc') || isempty(fPET.cov.in.pc)
        fPET.cov.in.pc = size(R.roi,1);
    end
    [networks, score, latent, ~, explained] = pca(R.roi, 'NumComponents', fPET.cov.in.pc);
    save(fullfile(fPET.dir.result, sprintf('Cov_PCA_n%i.mat', size(Y.d,4))), 'networks', 'score', 'latent', 'explained');
    disp('PCA decomposition complete.')
end

% optional jackknife leave-one-out decomposition
if fPET.cov.in.jk == true
    rLOO = zeros(size(R.roi,2), size(R.roi,2), size(R.roi,1));
    
    for s = 1:size(R.roi,1)
        R.roi_m = R.roi;
        R.roi_m(s,:) = [];

        
        if isempty(fPET.cov.X.add.d)
            rLOO(:,:,s) = corr(R.roi_m, 'rows','complete');
        else
            R.add = fPET.cov.X.add.d;
            R.add(s,:) = [];
            rLOO(:,:,s) = partialcorr(R.roi_m, R.add, 'rows','complete');
        end
    end
    
    r_JK = zeros(size(R.roi,2), size(R.roi,2), size(R.roi, 1));
    for s = 1:size(R.roi,1)
         r_JK(:,:,s) = size(R.roi,1) * r - (size(R.roi,1) - 1) * rLOO(:,:,s);
         r_JK(:,:,s) = r_JK(:,:,s) - diag(diag(r_JK(:,:,s))) + eye(size(R.roi,2));
    end

    r_var 			   = var(rLOO, 0, 3);
    rCov               = r_JK;
    variance           = r_var;
    save(fullfile(fPET.dir.result, sprintf('Cov_JK_n%i.mat', size(Y.d,4))), 'rLOO', 'rCov', 'variance');
    disp('Jackknife leave-one-out decomposition complete.')
end

fPET.cov.complete = 1;
save(fullfile(fPET.dir.result, 'fPET_cov.mat'), 'fPET');
disp('covariance calculation complete.')
end

