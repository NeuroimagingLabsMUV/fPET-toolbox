function fpet_tlbx_psc(fpetbatch);
% fPET toolbox: percent signal change
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria

disp('running percent signal change calculations.')

% set defaults
pn = fpet_tlbx_psc_setup(fpetbatch);

% psc
fpet_tlbx_psc_calc(pn);

end




