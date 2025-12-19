function fpetbatch = updateDefaults(handles, fpetbatch)
% fPET toolbox: fpetbach variable transfer
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria

% Switch based on the currently selected menu
switch handles.Menu
    case 1 % Basic Settings
        fpetbatch.run_glm = strcmp(handles.Table.Data{1, 2}, 'true');
        fpetbatch.glm.in.data = handles.Table.Data{2, 2};
        fpetbatch.glm.in.framelength = str2num(handles.Table.Data{3, 2});
        fpetbatch.glm.in.time = convertNameToVal(handles.Table.Data{4, 2});
    case 2 % Baseline Definitions and masking
        fpetbatch.glm.in.mask.bl = handles.Table.Data{1, 2};
        if ~isempty(handles.Table.Data{2, 2})
            fpetbatch.glm.in.mask.th =  cellfun(@str2num, split(handles.Table.Data{2, 2}, ','), 'UniformOutput', true)';
        end
        if ~isempty(handles.Table.Data{3, 2})
            fpetbatch.glm.in.mask.bl_excl = cellstr(handles.Table.Data{3, 2});
        end     
        fpetbatch.glm.in.bl_type = convertBLToVal(handles.Table.Data{4, 2});
        fpetbatch.glm.in.mask.calc = handles.Table.Data{5, 2};
        fpetbatch.glm.in.bl_start_fit = handles.Table.Data{6, 2};
    case 3 % Filtering and nuissance regression
        fpetbatch.glm.in.fil.apply = strcmp(handles.Table.Data{1, 2}, 'true');
        fpetbatch.glm.in.fil.order = str2num(handles.Table.Data{2, 2});
        fpetbatch.glm.in.fil.cutoff = str2num(handles.Table.Data{3, 2});
        fpetbatch.glm.in.regr_motion = handles.Table.Data{4, 2};
        fpetbatch.glm.in.regr_motion_pca = strcmp(handles.Table.Data{5, 2}, 'true');
        fpetbatch.glm.in.regr_add = handles.Table.Data{6, 2};
    case 4 % Task Regressors (if applicable)
       % fpetbatch.glm.in.stim_dur = str2num(handles.Table.Data{1, 2});
       
        splt = split(handles.Table.Data(4:end,2), ' - ');
        if ~isempty(splt)
            fpetbatch.glm.in.regr = [];
            Rv = cellfun(@(x) str2double(split(regexprep(x, '[^0-9.,]', ''), ',')), splt, 'UniformOutput', false);
            if size(Rv,2) == 1
                fpetbatch.glm.in.regr(1).start = cell2mat(squeeze(Rv(1)));
                fpetbatch.glm.in.regr(1).end = cell2mat(squeeze(Rv(2)));
                fpetbatch.glm.in.regr(1).name = handles.Table.Data{4,1};
            else
                for r = 1 : size(handles.Table.Data(4:end,1),1)
                    fpetbatch.glm.in.regr(r).start = cell2mat(squeeze(Rv(r,1,:)))';
                    fpetbatch.glm.in.regr(r).end = cell2mat(squeeze(Rv(r,2,:)))';
                    fpetbatch.glm.in.regr(r).name = handles.Table.Data{3+r,1};
                end
            end
        else
            fpetbatch.glm.in.regr(1).name = '';
            fpetbatch.glm.in.regr(1).end = [];
            fpetbatch.glm.in.regr(1).start = [];
        end
    case 5 % Quantification/PSC1
        fpetbatch.run_psc = strcmp(handles.Table.Data{1, 2}, 'true');
        fpetbatch.run_quant = strcmp(handles.Table.Data{2, 2}, 'true');
        fpetbatch.quant.in.time = convertQuantToVal(handles.Table.Data{3, 2});
        fpetbatch.quant.in.wb = handles.Table.Data{4, 2};
        fpetbatch.quant.in.plasma = handles.Table.Data{5, 2};
        fpetbatch.quant.in.pwbr = handles.Table.Data{6, 2};
        fpetbatch.quant.in.parent = handles.Table.Data{7, 2};
        fpetbatch.quant.in.pwbr_fit = convertPlasmaToVal(handles.Table.Data{8, 2});
        fpetbatch.quant.in.lc = str2num(handles.Table.Data{9, 2});
        fpetbatch.quant.in.vb = str2num(handles.Table.Data{10, 2});
        fpetbatch.quant.in.bloodlvl = str2num(handles.Table.Data{11, 2});
        fpetbatch.quant.in.tstar = str2num(handles.Table.Data{12, 2});
    case 6 % Advanced Settings
        fpetbatch.glm.in.regr_motion_incomplete = convertPadToVal(handles.Table.Data{1, 2});
        fpetbatch.glm.in.regr_orth = strcmp(handles.Table.Data{2, 2}, 'true');
        fpetbatch.glm.in.weight = str2num(handles.Table.Data{3, 2});
        fpetbatch.glm.in.rem_start = str2num(handles.Table.Data{4, 2});
        fpetbatch.glm.in.rem_end = str2num(handles.Table.Data{5, 2});
        if ~isempty(handles.Table.Data{6, 2}) fpetbatch.glm.in.data_incomplete.flag = strcmp(handles.Table.Data{6, 2}, 'true'); else fpetbatch.glm.in.data_incomplete.flag = []; end
        fpetbatch.glm.in.data_incomplete.start = str2num(handles.Table.Data{7, 2});
        fpetbatch.glm.in.data_incomplete.end = str2num(handles.Table.Data{8, 2});
    case 7 % TAC Plot
        fpetbatch.run_tacplot = strcmp(handles.Table.Data{1, 2}, 'true');
        fpetbatch.tacplot.in.regr = str2num(handles.Table.Data{2, 2});
        fpetbatch.tacplot.in.dir =  handles.Table.Data{3, 2};
        fpetbatch.tacplot.in.mask = handles.Table.Data{4, 2};
        fpetbatch.tacplot.in.indiv = strcmp(handles.Table.Data{5, 2}, 'true');
        fpetbatch.tacplot.in.average = strcmp(handles.Table.Data{6, 2}, 'true');
        fpetbatch.tacplot.in.raw = strcmp(handles.Table.Data{7, 2}, 'true');
    case 8 % Connectivity
        fpetbatch.run_conn = strcmp(handles.Table.Data{1, 2}, 'true');
        fpetbatch.conn.in.data = handles.Table.Data{2, 2};
        fpetbatch.conn.in.type = convertConnToVal(handles.Table.Data{3, 2});
        fpetbatch.conn.in.bl_start_fit = str2num(handles.Table.Data{4, 2});
        fpetbatch.conn.in.atlas = handles.Table.Data{5, 2};
      %  fpetbatch.conn.in.fil.order = str2num(handles.Table.Data{6, 2});
      %  fpetbatch.conn.in.fil.cutoff = cellfun(@str2num, split(handles.Table.Data{7, 2}, ' - '))';
        fpetbatch.conn.in.regr_motion = handles.Table.Data{6, 2};
        fpetbatch.conn.in.regr_motion_pca = strcmp(handles.Table.Data{7, 2}, 'true');
        fpetbatch.conn.in.regr_add = handles.Table.Data{8, 2};
        fpetbatch.conn.in.mask_bl = handles.Table.Data{9, 2};
        fpetbatch.conn.in.framelength = str2num(handles.Table.Data{10, 2});
        fpetbatch.conn.in.time = convertNameToVal(handles.Table.Data{11, 2});
        fpetbatch.conn.in.mask_wm = handles.Table.Data{12,2};
        fpetbatch.conn.in.mask_csf = handles.Table.Data{13,2};
    case 9 % Advanced Connectivity
        fpetbatch.conn.in.rem_start = str2num(handles.Table.Data{1, 2});
        fpetbatch.conn.in.rem_end = str2num(handles.Table.Data{2, 2});
        fpetbatch.conn.in.regr_motion_incomplete = convertPadToVal(handles.Table.Data{3, 2});
        fpetbatch.conn.in.data_norm = handles.Table.Data{4,2};
        fpetbatch.conn.in.nui_t = str2num(handles.Table.Data{5,2});
        fpetbatch.conn.in.mask_calc = handles.Table.Data{6,2};
        fpetbatch.conn.in.fil.cutoff = cellfun(@str2num, split(handles.Table.Data{7, 2}, ' - '))';
        fpetbatch.conn.in.fil.sigma_t = str2num(handles.Table.Data{8,2});
        fpetbatch.conn.in.fil.sigma_s = str2num(handles.Table.Data{9,2});
    case 10 % Covariance
        fpetbatch.run_cov = strcmp(handles.Table.Data{1, 2}, 'true');
        fpetbatch.cov.in.data = handles.Table.Data{2, 2};
        fpetbatch.cov.in.atlas = handles.Table.Data{3, 2};
        fpetbatch.cov.in.mask_norm = handles.Table.Data{4, 2};
        fpetbatch.cov.in.regr_add = handles.Table.Data{5, 2};
        fpetbatch.cov.in.jk = handles.Table.Data{6, 2};
        fpetbatch.cov.in.pca = handles.Table.Data{7, 2};
        fpetbatch.cov.in.pc = str2num(handles.Table.Data{8, 2});
        fpetbatch.cov.in.ica = handles.Table.Data{9, 2};
        fpetbatch.cov.in.ic = str2num(handles.Table.Data{10, 2});
    case 11 % ICA
        fpetbatch.run_ica = strcmp(handles.Table.Data{1, 2}, 'true');
        fpetbatch.ica.in.data = handles.Table.Data{2, 2};
        fpetbatch.ica.in.pca = strcmp(handles.Table.Data{3, 2}, 'true');
        fpetbatch.ica.in.pc = str2num(handles.Table.Data{4, 2});
        fpetbatch.ica.in.ic = str2num(handles.Table.Data{5, 2});
        fpetbatch.ica.in.rem_start = str2num(handles.Table.Data{6,2});
        fpetbatch.ica.in.rem_end = str2num(handles.Table.Data{7,2});
        fpetbatch.ica.in.framelength = str2num(handles.Table.Data{8,2});
        fpetbatch.ica.in.time = convertNameToVal(handles.Table.Data{9,2});
        fpetbatch.ica.in.mask.calc = handles.Table.Data{10, 2};
    case 13
        fpetbatch.dir.result = handles.Table.Data{1, 2};
        fpetbatch.overwrite = strcmp(handles.Table.Data{2, 2}, 'true');
end
end
