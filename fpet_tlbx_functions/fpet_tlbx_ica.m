function fpet_tlbx_ica(fpetbatch);
% fPET toolbox: independent component analysis
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria

disp('running ica calculations.')

% set defaults
pn = fpet_tlbx_ica_setup(fpetbatch);

% conn
fpet_tlbx_ica_calc(pn);

end
