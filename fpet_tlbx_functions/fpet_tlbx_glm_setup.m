function [Y, fpet_param] = fpet_tlbx_glm_setup(fpetbatch);
% fPET toolbox: set default values for glm
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria

% load defaults
fpet_defaults = fpet_tlbx_defaults();
fPET.v = fpetbatch.v;

% result directory
if isfield(fpetbatch,'dir') && isfield(fpetbatch.dir,'result') && ~isempty(fpetbatch.dir.result)
    fPET.dir.result = fpetbatch.dir.result;
else
    fPET.dir.result = pwd;
end
cd(fPET.dir.result);

% check removal of initial or final frames (advanced)
if isfield(fpetbatch.glm.in,'rem_start') && ~isempty(fpetbatch.glm.in.rem_start)
    if fpetbatch.glm.in.time == 1
        fPET.glm.X.rem.start = round(fpetbatch.glm.in.rem_start/fpetbatch.glm.in.framelength);
    elseif fpetbatch.glm.in.time == 2
        fPET.glm.X.rem.start = fpetbatch.glm.in.rem_start;
    end
else
    fPET.glm.X.rem.start = fpet_defaults.glm.in.rem_start;
end
if isfield(fpetbatch.glm.in,'rem_end') && ~isempty(fpetbatch.glm.in.rem_end)
    if fpetbatch.glm.in.time == 1
        fPET.glm.X.rem.end = round(fpetbatch.glm.in.rem_end/fpetbatch.glm.in.framelength);
    elseif fpetbatch.glm.in.time == 2
        fPET.glm.X.rem.end = fpetbatch.glm.in.rem_end;
    end
else
    fPET.glm.X.rem.end = fpet_defaults.glm.in.rem_end;
end

% check PET data completeness (advanced)
if isfield(fpetbatch.glm.in,'data_incomplete') && isfield(fpetbatch.glm.in.data_incomplete,'flag') && ~isempty(fpetbatch.glm.in.data_incomplete.flag) && (fpetbatch.glm.in.data_incomplete.flag == 1)
    fPET.Y.incomplete = 1;
    if fpetbatch.glm.in.time == 1
        fPET.glm.X.incomplete.start = round(fpetbatch.glm.in.data_incomplete.start/fpetbatch.glm.in.framelength);
        fPET.glm.X.incomplete.end = round(fpetbatch.glm.in.data_incomplete.end/fpetbatch.glm.in.framelength);
    elseif fpetbatch.glm.in.time == 2
        fPET.glm.X.incomplete.start = fpetbatch.glm.in.data_incomplete.start;
        fPET.glm.X.incomplete.end = fpetbatch.glm.in.data_incomplete.end;
    end
    if isfield(fpetbatch.glm.in.data_incomplete,'no_anchor') && ~isempty(fpetbatch.glm.in.data_incomplete.no_anchor) && (fpetbatch.glm.in.data_incomplete.no_anchor == 1)
        fPET.glm.X.incomplete.no_anchor = 1;
    else
        fPET.glm.X.incomplete.no_anchor = 0;
    end
else
    fPET.Y.incomplete = 0;
    fPET.glm.X.incomplete.start = fpet_defaults.glm.in.data_incomplete.start;
    fPET.glm.X.incomplete.end = fpet_defaults.glm.in.data_incomplete.end;
end



% mandatory input
% data
Y = fpet_tlbx_load4d(fpetbatch.glm.in.data, fPET.glm.X.rem.start, fPET.glm.X.rem.end);
fPET.Y.h = Y.h;
fPET.Y.dir = Y.dir;

% mask for baseline definition
M.bl.h = spm_vol(fpetbatch.glm.in.mask.bl);
M.bl.d = spm_read_vols(M.bl.h);
M.bl.d(isinf(M.bl.d)) = 0;
M.bl.d(isnan(M.bl.d)) = 0;
M.bl.d(M.bl.d~=0) = 1;

% framelength
fPET.framelength = fpetbatch.glm.in.framelength;

% time vector
if fPET.Y.incomplete == 1
    fPET.tvec = [];
    for ind = 1:numel(fPET.glm.X.incomplete.start)
        fPET.tvec = [fPET.tvec fPET.glm.X.incomplete.start(ind):fPET.glm.X.incomplete.end(ind)];
    end
    if fpetbatch.glm.in.time == 1
    elseif fpetbatch.glm.in.time == 2
        fPET.tvec = fPET.tvec*fPET.framelength;
    end
else
    fPET.tvec = (1:numel(Y.h))*fPET.framelength;
end
fPET.tvec = fPET.tvec - fPET.framelength/2;


% optional input, set defaults if undefined
% mask(s) with voxels not included in baseline definition
if isfield(fpetbatch.glm.in.mask,'bl_excl') && ~isempty(fpetbatch.glm.in.mask.bl_excl) && ~isempty(fpetbatch.glm.in.mask.bl_excl{1})
    fPET.glm.M.blex.h = {};
    fPET.glm.M.blex.th = [];
    nr_m_blex = numel(fpetbatch.glm.in.mask.bl_excl);
    if ~isfield(fpetbatch.glm.in.mask,'th') || isempty(fpetbatch.glm.in.mask.th)
        fpetbatch.glm.in.mask.th = NaN(nr_m_blex,1);
    end
    for ind = 1:nr_m_blex
        M.blex.h{ind} = spm_vol(fpetbatch.glm.in.mask.bl_excl{ind});
        M.blex.d = spm_read_vols(M.blex.h{ind});
        M.blex.d(isinf(M.blex.d)) = 0;
        M.blex.d(isnan(M.blex.d)) = 0;
        th = fpetbatch.glm.in.mask.th(ind);
        if ~isnan(th)
            if th == 0
                M.blex.d(M.blex.d<th) = 0;
            else
                M.blex.d((M.blex.d<th) & (M.blex.d>-th)) = 0;
            end
        end
        M.blex.d(M.blex.d~=0) = 1;
        M.bl.d(M.blex.d==1) = 0;
        fPET.glm.M.blex.h{ind} = M.blex.h{ind};
        fPET.glm.M.blex.th(ind) = th;
    end
end
M.bl.d = logical(M.bl.d);
fPET.glm.M.bl = M.bl;

% mask where calculations are done
if isfield(fpetbatch.glm.in.mask,'calc') && ~isempty(fpetbatch.glm.in.mask.calc)
    M.calc.h = spm_vol(fpetbatch.glm.in.mask.calc);
    M.calc.d = spm_read_vols(M.calc.h);
    M.calc.d(isinf(M.calc.d)) = 0;
    M.calc.d(isnan(M.calc.d)) = 0;
    M.calc.d(M.calc.d~=0) = 1;
else
    M.calc.d = ones(size(M.bl.d));
end
M.calc.d = logical(M.calc.d);
fPET.glm.M.calc = M.calc;

% stimulation regressor(s)
if isfield(fpetbatch.glm.in,'regr') && ~isempty(fpetbatch.glm.in.regr)
    nr_regr_stim = numel(fpetbatch.glm.in.regr);
    X.stim.d = zeros(numel(Y.h),nr_regr_stim);
    X.stim.length = zeros(1,nr_regr_stim);
    for ind = 1:nr_regr_stim
        for ind2 = 1:numel(fpetbatch.glm.in.regr(ind).start)
            if fpetbatch.glm.in.time == 1
                s = round(fpetbatch.glm.in.regr(ind).start(ind2)/fpetbatch.glm.in.framelength);
                e = round(fpetbatch.glm.in.regr(ind).end(ind2)/fpetbatch.glm.in.framelength);
                % adjust for incomplete data
                if fPET.Y.incomplete == 1
                    temp = 0;
                    for ind3 = 1:find(fPET.glm.X.incomplete.start<s,1,'last')
                        if ind3 == 1
                            temp = temp + (fPET.glm.X.incomplete.start(ind3)-1);
                        else
                            temp = temp + ((fPET.glm.X.incomplete.start(ind3)-1) - (fPET.glm.X.incomplete.end(ind3-1)+1));
                        end
                    end
                    s = s - temp;
                    e = e - temp;
                end
            elseif fpetbatch.glm.in.time == 2
                s = fpetbatch.glm.in.regr(ind).start(ind2);
                e = fpetbatch.glm.in.regr(ind).end(ind2);
            end
            X.stim.d(s:e,ind) = 1;
            X.stim.length(ind2,ind) = e-s+1;
        end
    end
    X.stim.d = cumsum(X.stim.d,1);
    % scale regressor to slope of 1 kBq/min
    X.stim.d = X.stim.d*fpetbatch.glm.in.framelength/60;
else
    X.stim.d = [];
    X.stim.length = fpet_defaults.glm.in.stim_dur/fpetbatch.glm.in.framelength;      % default task duration for lp filter
end
fPET.glm.X.stim = X.stim;

% motion regressors
if isfield(fpetbatch.glm.in,'regr_motion') && ~isempty(fpetbatch.glm.in.regr_motion)
    X.motion.h = fpetbatch.glm.in.regr_motion;
    X.motion.d = importdata(X.motion.h);
    if size(X.motion.d,2) > size(X.motion.d,1)
        X.motion.d = X.motion.d';
    end
    % zero padding to full dataset (advanced)
    if isfield(fpetbatch.glm.in,'regr_motion_incomplete') && ~isempty(fpetbatch.glm.in.regr_motion_incomplete)
        if fpetbatch.glm.in.regr_motion_incomplete == 1
            X.motion.d = [zeros(numel(Y.h_orig)-size(X.motion.d,1), size(X.motion.d,2)); X.motion.d];
        elseif fpetbatch.glm.in.regr_motion_incomplete == 2
            X.motion.d = [X.motion.d; zeros(numel(Y.h_orig)-size(X.motion.d,1), size(X.motion.d,2))];
        end
    end
    % remove initial or final frames (advanced)
    if ~isempty(fPET.glm.X.rem.start)
        X.motion.d(1:fPET.glm.X.rem.start,:) = [];
    end
    if ~isempty(fPET.glm.X.rem.end)
        X.motion.d(end-fPET.glm.X.rem.end+1:end,:) = [];
    end
    % PCA, perform by default, use tradeoff
    if ~isfield(fpetbatch.glm.in,'regr_motion_pca') || isempty(fpetbatch.glm.in.regr_motion_pca) || (fpetbatch.glm.in.regr_motion_pca == 1)
        [~, score, ~, ~, exp] = pca(X.motion.d);
        numberOfComponents = findElbow(exp);
        X.motion.d_final = zscore(score(:,1:numberOfComponents));
    else
        X.motion.d_final = X.motion.d;
    end
else
    X.motion.d_final = [];
end
fPET.glm.X.motion = X.motion;

% additional regressors
if isfield(fpetbatch.glm.in,'regr_add') && ~isempty(fpetbatch.glm.in.regr_add)
    X.add.h = fpetbatch.glm.in.regr_add;
    X.add.d = importdata(X.add.h);
    if size(X.add.d,2) > size(X.add.d,1)
        X.add.d = X.add.d';
    end
    % remove initial or final frames (advanced)
    if ~isempty(fPET.glm.X.rem.start)
        X.add.d(1:fPET.glm.X.rem.start,:) = [];
    end
    if ~isempty(fPET.glm.X.rem.end)
        X.add.d(end-fPET.glm.X.rem.end+1:end,:) = [];
    end
else
    X.add.d = [];
end
fPET.glm.X.add = X.add;

% baseline regressor definition
fPET.glm.X.bl_prob = 0;
if isfield(fpetbatch.glm.in,'bl_prob') && ~isempty(fpetbatch.glm.in.bl_prob) && (fpetbatch.glm.in.bl_prob == 1)
    % probabilistic
    temp = which('fpet_tlbx_run');
    M.bl_prob.h = spm_vol(fullfile(temp(1:end-16),'fpet_data','prob','FDG_human_KPM.nii'));
    M.bl_prob.d = spm_read_vols(M.bl_prob.h);
    M.bl_prob.d(isinf(M.bl_prob.d)) = 0;
    M.bl_prob.d(isnan(M.bl_prob.d)) = 0;
    [~,bl_prob_max] = max(M.bl_prob.d,[],4);
    bl_prob_max(M.bl.d==0) = 0;
    X.bl = zeros(numel(Y.h),size(M.bl_prob.d,4));
    for ind_bl = 1:size(M.bl_prob.d,4)
        for ind = 1:numel(Y.h)
            temp = Y.d(:,:,:,ind);
            if nnz(bl_prob_max==ind_bl)
                X.bl(ind,ind_bl) = nanmean(temp(bl_prob_max==ind_bl));
            else
                X.bl(ind,ind_bl) = nanmean(temp(M.bl.d));
            end
        end
    end
    clear temp;
    X.bl(isnan(X.bl)) = 0;
    fpet_param.M.bl_prob = M.bl_prob;
    fPET.glm.X.bl_prob = 1;
else
    % standard
    X.bl = zeros(numel(Y.h),1);
    for ind = 1:numel(Y.h)
        temp = Y.d(:,:,:,ind);
        X.bl(ind,1) = nanmean(temp(M.bl.d));
    end
    clear temp;
    X.bl(isnan(X.bl)) = 0;
end
% third order polynomial
if isfield(fpetbatch.glm.in,'bl_type') && ~isempty(fpetbatch.glm.in.bl_type) && (fpetbatch.glm.in.bl_type == 2)
    if fpetbatch.glm.in.time == 1
        bl_start_fit = round(fpetbatch.glm.in.bl_start_fit/fpetbatch.glm.in.framelength);
    elseif fpetbatch.glm.in.time == 2
        bl_start_fit = fpetbatch.glm.in.bl_start_fit;
    end
    x = [bl_start_fit:numel(X.bl(:,1))]';
    X_temp = [X.stim.d X.motion.d_final X.add.d];
    for ind_bl = 1:size(X.bl,2)
        b = glmfit([x x.^2 x.^3 X_temp(bl_start_fit:end,:)], X.bl(bl_start_fit:end,ind_bl));
        bl_fit = b(1) + b(2)*x + b(3)*(x.^2) + b(4)*(x.^3);
        X.bl(:,ind_bl) = [X.bl(1:bl_start_fit-1,ind_bl); bl_fit];
    end
    fPET.glm.X.start_fit = bl_start_fit;
end
    
fPET.glm.X.bl = X.bl;

% orthogonalization of stimulation regressors
if isfield(fpetbatch.glm.in,'bl_prob') && ~isempty(fpetbatch.glm.in.bl_prob) && (fpetbatch.glm.in.bl_prob == 1)
    X.bl_temp = mean(X.bl,2);
else
    X.bl_temp = X.bl;
end
if (~isfield(fpetbatch.glm.in,'regr_orth') || isempty(fpetbatch.glm.in.regr_orth) || (fpetbatch.glm.in.regr_orth == 1)) && (~isempty(X.stim.d))
    X.stim.d_orth = zeros(size(X.stim.d));
    for ind = 1:nr_regr_stim
        temp = spm_orth([X.bl_temp X.stim.d(:,ind)]);
        X.stim.d_orth(:,ind) = temp(:,2);
    end
    fPET.glm.X.stim.d_orth = X.stim.d_orth;
    fPET.glm.X.all = [X.bl_temp X.stim.d_orth X.add.d X.motion.d_final];
else
    fPET.glm.X.all = [X.bl_temp X.stim.d X.add.d X.motion.d_final];
end

% names of regressors
fPET.glm.X.name = {};
fPET.glm.X.name{1} = 'constant';
fPET.glm.X.name{2} = 'baseline';
if isfield(fpetbatch.glm.in,'regr') && ~isempty(fpetbatch.glm.in.regr)
    for ind = 1:numel(fpetbatch.glm.in.regr)
        if isfield(fpetbatch.glm.in.regr(ind),'name') && ~isempty(fpetbatch.glm.in.regr(ind).name)
            fPET.glm.X.name{ind+2} = fpetbatch.glm.in.regr(ind).name;
        else
            fPET.glm.X.name{ind+2} = sprintf('stim%i', ind);
        end
    end
end
for ind = 1:size(X.add.d,2)
    fPET.glm.X.name{numel(fPET.glm.X.name)+1} = sprintf('add%i', ind);
end
for ind = 1:size(X.motion.d_final,2)
    fPET.glm.X.name{numel(fPET.glm.X.name)+1} = sprintf('motion%i', ind);
end

% define filter
if (isfield(fpetbatch.glm.in,'fil') && isfield(fpetbatch.glm.in.fil,'apply')) && (isempty(fpetbatch.glm.in.fil.apply) || (fpetbatch.glm.in.fil.apply == 0))
	fPET.glm.fil.apply = 0;
else
    fil.apply = 1;
    if ~isfield(fpetbatch.glm.in,'fil') || ~isfield(fpetbatch.glm.in.fil,'order') || isempty(fpetbatch.glm.in.fil.order)
        fil.order = fpet_defaults.glm.in.fil.order;
    else
        fil.order = round(fpetbatch.glm.in.fil.order/2);
    end
    if ~isfield(fpetbatch.glm.in,'fil') || ~isfield(fpetbatch.glm.in.fil,'cutoff') || isempty(fpetbatch.glm.in.fil.cutoff)
        fil.cutoff = 1/(round(mean(X.stim.length(:)))*fpetbatch.glm.in.framelength/2);
    else
        if fpetbatch.glm.in.time == 1
            fil.cutoff = 1/fpetbatch.glm.in.fil.cutoff;
        elseif fpetbatch.glm.in.time == 2
            fil.cutoff = 1/(fpetbatch.glm.in.fil.cutoff*fpetbatch.glm.in.framelength);
        end
    end
    fil.f_nyq = (1/fpetbatch.glm.in.framelength)/2;
    fil.b = fir1(fil.order, fil.cutoff/fil.f_nyq);
    fil.a = 1;
    fPET.glm.fil = fil;
end

% define weights (Advanced)
if isfield(fpetbatch.glm.in,'weight') && ~isempty(fpetbatch.glm.in.weight)
    fPET.glm.weight = fpetbatch.glm.in.weight;
    % remove initial or final frames (advanced)
    if ~isempty(fPET.glm.X.rem.start)
        fPET.glm.weight(1:fPET.glm.X.rem.start,:) = [];
    end
    if ~isempty(fPET.glm.X.rem.end)
        fPET.glm.weight(end-fPET.glm.X.rem.end+1:end,:) = [];
    end
else
    fPET.glm.weight = ones(size(X.bl,1),1);
end

% adding anchor point for incomplete data (advanced)
if (fPET.Y.incomplete == 1) && (fPET.glm.X.incomplete.start(1) ~= 1) && (fPET.glm.X.incomplete.no_anchor == 0)
    fPET.glm.weight = cat(1, 10, fPET.glm.weight);
%     Y.d = cat(4, zeros([Y.h(1).dim 1]), Y.d);     % done in calc after filtering
    fPET.glm.X.bl = cat(1, zeros(1,size(X.bl,2)), X.bl);
    if ~isempty(X.stim.d)
        fPET.glm.X.stim.d = cat(1, zeros(1,size(X.stim.d,2)), X.stim.d);
    end
    if isfield(X.stim,'d_orth')
        fPET.glm.X.stim.d_orth = cat(1, zeros(1,size(X.stim.d_orth,2)), X.stim.d_orth);
    end
    if ~isempty(X.add.d)
        fPET.glm.X.add = cat(1, zeros(1,size(X.add.d,2)), X.add.d);
    end
    if ~isempty(X.motion.d_final)
        fPET.glm.X.motion.d_final = cat(1, zeros(1,size(X.motion.d_final,2)), X.motion.d_final);
    end
    fPET.glm.X.all = cat(1, zeros(1,size(fPET.glm.X.all,2)), fPET.glm.X.all);
    fPET.tvec = [0 fPET.tvec];
end

% save values
save(fullfile(fPET.dir.result, 'fPET_glm.mat'), 'fPET');
fpet_param.pn = fPET.dir.result;

end



% % % % % 
function [ei] = findElbow(y)
y = y(:);
% scale x-axis to max 1
x  = linspace(0, 1, numel(y))';
 % scale y-axis to max 1
y = y / max(y);
% calculate distance from origin
d  = sqrt(y .^ 2 + x .^ 2);
% minimize distance
ei = find(d == min(d));
end


