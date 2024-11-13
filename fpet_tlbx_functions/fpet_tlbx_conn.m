function fpet_tlbx_conn(fpetbatch);
% fPET toolbox: molecular connectivity
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria

disp('running connectivity calculations.')

% set defaults
[Y, pn] = fpet_tlbx_conn_setup(fpetbatch);

% conn
fpet_tlbx_conn_calc(Y, pn);

end





