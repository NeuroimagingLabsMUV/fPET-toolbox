function fpet_tlbx_cov(fpetbatch);
% fPET toolbox: molecular covariance
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria

disp('running covariance calculations.')

% set defaults
pn = fpet_tlbx_cov_setup(fpetbatch);

% conn
fpet_tlbx_cov_calc(pn);

end
