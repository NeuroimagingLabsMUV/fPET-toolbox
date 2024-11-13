function pn = fpet_tlbx_cov_setup(fpetbatch);
% fPET toolbox: set default values for covariance
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria

% result directory
if isfield(fpetbatch.dir,'result') && ~isempty(fpetbatch.dir.result)
    fPET.dir.result = fpetbatch.dir.result;
else
    fPET.dir.result = pwd;
end
cd(fPET.dir.result);

% data
for ind = 1:numel(fpetbatch.cov.in.data)
    Y.h(ind) = spm_vol(fpetbatch.cov.in.data{ind});
end
fPET.Y.h = Y.h;

% atlas
M.atlas.h = spm_vol(fpetbatch.cov.in.atlas);
M.atlas.d = spm_read_vols(M.atlas.h);
M.atlas.d(isinf(M.atlas.d)) = 0;
M.atlas.d(isnan(M.atlas.d)) = 0;
fPET.cov.M.atlas = M.atlas;

% mask for normalization
if isfield(fpetbatch.cov.in,'mask_norm') && ~isempty(fpetbatch.cov.in.mask_norm)
    M.norm.h = spm_vol(fpetbatch.cov.in.mask_norm);
    M.norm.d = spm_read_vols(M.norm.h);
    M.norm.d(isinf(M.norm.d)) = 0;
    M.norm.d(isnan(M.norm.d)) = 0;
    M.norm.d(M.norm.d~=0) = 1;
    M.norm.d = logical(M.norm.d);
else
    M.norm.d = [];
end
fPET.cov.M.norm = M.norm;

% additional regressors
if isfield(fpetbatch.cov.in,'regr_add') && ~isempty(fpetbatch.cov.in.regr_add)
    X.add.h = fpetbatch.cov.in.regr_add;
    X.add.d = importdata(X.add.h);
    if size(X.add.d,2) > size(X.add.d,1)
        X.add.d = X.add.d';
    end
else
    X.add.d = [];
end
fPET.cov.X.add = X.add;

% save values
save(fullfile(fPET.dir.result, 'fPET_cov.mat'), 'fPET');
pn = fPET.dir.result;

end


