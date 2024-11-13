function fpet_defaults = fpet_tlbx_defaults();
% fPET toolbox: general default values
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria

% general
fpet_defaults.dir.result = '';
fpet_defaults.overwrite = 0;


% glm
fpet_defaults.run_glm = 0;

fpet_defaults.glm.in.data = '';
fpet_defaults.glm.in.framelength = [];
fpet_defaults.glm.in.time = [];
fpet_defaults.glm.in.mask.bl = '';
fpet_defaults.glm.in.bl_type = 1;
fpet_defaults.glm.in.bl_start_fit = [];
fpet_defaults.glm.in.mask.calc = '';
fpet_defaults.glm.in.mask.bl_excl = '';
fpet_defaults.glm.in.mask.th = [];

% fpet_defaults.glm.in.regr = '';
fpet_defaults.glm.in.regr.name = '';
fpet_defaults.glm.in.regr.start = [];
fpet_defaults.glm.in.regr.end = [];
fpet_defaults.glm.in.rem_start = [];
fpet_defaults.glm.in.rem_end = [];
fpet_defaults.glm.in.stim_dur = 300;     % default stimulus duration [sec]
fpet_defaults.glm.in.regr_orth = 1;
fpet_defaults.glm.in.weight = [];

fpet_defaults.glm.in.regr_motion = '';
fpet_defaults.glm.in.regr_motion_incomplete = [];
fpet_defaults.glm.in.regr_motion_pca = 1;

fpet_defaults.glm.in.regr_add = '';

fpet_defaults.glm.in.filter.apply = 1;
fpet_defaults.glm.in.filter.order = 6;     % half of actual filter order (bec filtfilt is used)
fpet_defaults.glm.in.filter.cutoff = [];

fpet_defaults.glm.in.data_incomplete.flag = [];
fpet_defaults.glm.in.data_incomplete.start = [];
fpet_defaults.glm.in.data_incomplete.end = [];


% pecent signal change
fpet_defaults.run_psc = 0;


% quantification
fpet_defaults.run_quant = 0;

fpet_defaults.quant.in.time = [];
fpet_defaults.quant.in.wb = '';
fpet_defaults.quant.in.plasma = '';
fpet_defaults.quant.in.pwbr = '';
fpet_defaults.quant.in.pwbr_fit = 1;
fpet_defaults.quant.in.parent = '';
fpet_defaults.quant.in.lc = 0.89;
fpet_defaults.quant.in.vb = 0.05;
fpet_defaults.quant.in.bloodlvl = [];
fpet_defaults.quant.in.tstar = 1/3;


% tac plot
fpet_defaults.run_tacplot = 0;
fpet_defaults.tacplot.in.type = 1;  % 1=glm, 2=ica

fpet_defaults.tacplot.in.regr = [];
fpet_defaults.tacplot.in.dir = {};
fpet_defaults.tacplot.in.mask = '';

fpet_defaults.tacplot.in.indiv = 0;
fpet_defaults.tacplot.in.average = 1;
fpet_defaults.tacplot.in.raw = 0;

fpet_defaults.tacplot.in.ic_nr = [];
fpet_defaults.tacplot.in.framelength = [];


% ica
fpet_defaults.run_ica = 0;

fpet_defaults.ica.in.data = '';
fpet_defaults.ica.in.mask.calc = '';
fpet_defaults.ica.in.pca = 1;
fpet_defaults.ica.in.rem_start = [];
fpet_defaults.ica.in.rem_end = [];
fpet_defaults.ica.in.pc = 40;
fpet_defaults.ica.in.ic = 20;

fpet_defaults.ica.in.time = [];
fpet_defaults.ica.in.framelength = [];



% connectivity
fpet_defaults.run_conn = 0;

fpet_defaults.conn.in.data = '';
fpet_defaults.conn.in.framelength = [];
fpet_defaults.conn.in.time = [];
fpet_defaults.conn.in.atlas = '';

fpet_defaults.conn.in.mask_bl = '';
fpet_defaults.conn.in.bl_type = 3;
fpet_defaults.conn.in.bl_start_fit = [];

fpet_defaults.conn.in.rem_start = [];
fpet_defaults.conn.in.rem_end = [];

fpet_defaults.conn.in.regr_motion = '';
fpet_defaults.conn.in.regr_motion_incomplete = [];
fpet_defaults.conn.in.regr_motion_pca = 1;

fpet_defaults.conn.in.regr_add = '';
fpet_defaults.conn.in.filter.order = 4;         % half of actual filter order (bec filtfilt is used)
fpet_defaults.conn.in.filter.cutoff = [0.01 0.1];   % [Hz]


% covariance
fpet_defaults.run_cov = 0;

fpet_defaults.cov.in.data = '';
fpet_defaults.cov.in.atlas = '';
fpet_defaults.cov.in.mask_norm = '';
fpet_defaults.cov.in.regr_add = '';



