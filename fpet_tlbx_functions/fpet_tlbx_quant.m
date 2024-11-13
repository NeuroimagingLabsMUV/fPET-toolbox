function fpet_tlbx_quant(fpetbatch);
% fPET toolbox: quantification
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria

disp('running absolute quantification.')

% set defaults
pn = fpet_tlbx_quant_setup(fpetbatch);

% psc
fpet_tlbx_quant_calc(pn);

end

