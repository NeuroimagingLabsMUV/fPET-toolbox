function fpet_tlbx_glm(fpetbatch);
% fPET toolbox: general linear model
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria

disp('running glm calculations.')

% set defaults
[Y, fpet_param] = fpet_tlbx_glm_setup(fpetbatch);

% glm
fpet_tlbx_glm_calc(Y, fpet_param);

end

