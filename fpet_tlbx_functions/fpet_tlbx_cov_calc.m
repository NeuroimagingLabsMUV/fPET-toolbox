function fpet_tlbx_cov_calc(pn);
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
        norm_val = nanmean(d_temp(fPET.cov.M.norm.d==1));
        d_temp = d_temp/norm_val;
    end
    % extract roi values
    for ind_r = 1:numel(nr_roi)
        R.roi(ind,ind_r) = mean(d_temp(fPET.cov.M.atlas.d==nr_roi(ind_r)));
    end
end

% calculate covariance matrix
if isempty(fPET.cov.X.add.d)
    r = (corr(R.roi, 'rows','complete'))';
else
    r = (partialcorr(R.roi, fPET.cov.X.add, 'rows','complete'))';
end
z = 0.5 * log((1+r)./(1-r));

% save data
save(fullfile(fPET.dir.result, sprintf('Cov_n%i.mat', size(Y.d,4))), 'z');

fPET.cov.complete = 1;
save(fullfile(fPET.dir.result, 'fPET_cov.mat'), 'fPET');
disp('covariance calculation complete.')


end

