function fpet_tlbx_tacplot(fpetbatch);
% fPET toolbox: plot task-specific activation
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria

disp('running plots for time activity curves.')

% set defaults
fpetbatch = fpet_tlbx_tacplot_setup(fpetbatch);

% plot tacs
fpet_tlbx_tacplot_calc(fpetbatch);

end

