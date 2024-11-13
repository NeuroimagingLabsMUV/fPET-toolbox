function [Y, pn] = fpet_tlbx_conn_setup(fpetbatch);
% fPET toolbox: set default values for connectivity
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria

% load defaults
fpet_defaults = fpet_tlbx_defaults();

% result directory
if isfield(fpetbatch.dir,'result') && ~isempty(fpetbatch.dir.result)
    fPET.dir.result = fpetbatch.dir.result;
else
    fPET.dir.result = pwd;
end
cd(fPET.dir.result);

% check removal of initial or final frames (advanced)
if isfield(fpetbatch.conn.in,'rem_start') && ~isempty(fpetbatch.conn.in.rem_start)
    if fpetbatch.conn.in.time == 1
        fPET.conn.X.rem.start = round(fpetbatch.conn.in.rem_start/fpetbatch.conn.in.framelength);
    elseif fpetbatch.conn.in.time == 2
        fPET.conn.X.rem.start = fpetbatch.conn.in.rem_start;
    end
else
    fPET.conn.X.rem.start = fpet_defaults.conn.in.rem_start;
end
if isfield(fpetbatch.conn.in,'rem_end') && ~isempty(fpetbatch.conn.in.rem_end)
    if fpetbatch.conn.in.time == 1
        fPET.conn.X.rem.end = round(fpetbatch.conn.in.rem_end/fpetbatch.conn.in.framelength);
    elseif fpetbatch.conn.in.time == 2
        fPET.conn.X.rem.end = fpetbatch.conn.in.rem_end;
    end
else
    fPET.conn.X.rem.end = fpet_defaults.conn.in.rem_end;
end

% data
Y = fpet_tlbx_load4d(fpetbatch.conn.in.data, fPET.conn.X.rem.start, fPET.conn.X.rem.end);
fPET.Y.h = Y.h;
fPET.Y.dir = Y.dir;

% framelength
fPET.framelength = fpetbatch.conn.in.framelength;

% time vector
fPET.tvec = (1:numel(Y.h))*fPET.framelength;

% atlas
M.atlas.h = spm_vol(fpetbatch.conn.in.atlas);
M.atlas.d = spm_read_vols(M.atlas.h);
M.atlas.d(isinf(M.atlas.d)) = 0;
M.atlas.d(isnan(M.atlas.d)) = 0;
fPET.conn.M.atlas = M.atlas;

% motion regressors
if isfield(fpetbatch.conn.in,'regr_motion') && ~isempty(fpetbatch.conn.in.regr_motion)
    X.motion.h = fpetbatch.conn.in.regr_motion;
    X.motion.d = importdata(X.motion.h);
    if size(X.motion.d,2) > size(X.motion.d,1)
        X.motion.d = X.motion.d';
    end
    % zero padding to full dataset (advanced)
    if isfield(fpetbatch.conn.in,'regr_motion_incomplete') && ~isempty(fpetbatch.conn.in.regr_motion_incomplete)
        if fpetbatch.conn.in.regr_motion_incomplete == 1
            X.motion.d = [zeros(numel(Y.h_orig)-size(X.motion.d,1), size(X.motion.d,2)); X.motion.d];
        elseif fpetbatch.conn.in.regr_motion_incomplete == 2
            X.motion.d = [X.motion.d; zeros(numel(Y.h_orig)-size(X.motion.d,1), size(X.motion.d,2))];
        end
    end
    % remove initial or final frames (advanced)
    if ~isempty(fPET.conn.X.rem.start)
        X.motion.d(1:fPET.conn.X.rem.start,:) = [];
    end
    if ~isempty(fPET.conn.X.rem.end)
        X.motion.d(end-fPET.conn.X.rem.end+1:end,:) = [];
    end
    % PCA, perform by default, use tradeoff
    if ~isfield(fpetbatch.conn.in,'regr_motion_pca') || (fpetbatch.conn.in.regr_motion_pca == 1)
        [~, score, ~, ~, exp] = pca(X.motion.d);
        numberOfComponents = findElbow(exp);
        X.motion.d_final = zscore(score(:,1:numberOfComponents));
    else
        X.motion.d_final = X.motion.d;
    end
else
    X.motion.d_final = [];
end
fPET.conn.X.motion = X.motion;

% additional regressors
if isfield(fpetbatch.conn.in,'regr_add') && ~isempty(fpetbatch.conn.in.regr_add)
    X.add.h = fpetbatch.conn.in.regr_add;
    X.add.d = importdata(X.add.h);
    if size(X.add.d,2) > size(X.add.d,1)
        X.add.d = X.add.d';
    end
    % remove initial or final frames (advanced)
    if ~isempty(fPET.conn.X.rem.start)
        X.add.d(1:fPET.conn.X.rem.start,:) = [];
    end
    if ~isempty(fPET.conn.X.rem.end)
        X.add.d(end-fPET.conn.X.rem.end+1:end,:) = [];
    end
else
    X.add.d = [];
end
fPET.conn.X.add = X.add;

% baseline removal
% average tac +/- 3rd order polynomial fitting
fPET.conn.X.bl = [];
if fpetbatch.conn.in.bl_type == 1 || fpetbatch.conn.in.bl_type == 2
    % mask for baseline definition
    M.bl.h = spm_vol(fpetbatch.conn.in.mask_bl);
    M.bl.d = spm_read_vols(M.bl.h);
    M.bl.d(isinf(M.bl.d)) = 0;
    M.bl.d(isnan(M.bl.d)) = 0;
    M.bl.d(M.bl.d~=0) = 1;
    M.bl.d = logical(M.bl.d);
    fPET.conn.M.bl = M.bl;
    % baseline regressor definition
    X.bl = zeros(numel(Y.h),1);
    for ind = 1:numel(Y.h)
        temp = Y.d(:,:,:,ind);
        X.bl(ind,1) = nanmean(temp(M.bl.d));
    end
    clear temp;
    X.bl(isnan(X.bl)) = 0;
    
    % mask fitted with third order polynomial
    if fpetbatch.conn.in.bl_type == 2
        if fpetbatch.conn.in.time == 1
            bl_start_fit = round(fpetbatch.conn.in.bl_start_fit/fpetbatch.conn.in.framelength);
        elseif fpetbatch.conn.in.time == 2
            bl_start_fit = fpetbatch.conn.in.bl_start_fit;
        end
        x = [bl_start_fit:numel(X.bl)]';
        X_temp = [X.motion.d_final X.add.d];
        b = glmfit([x x.^2 x.^3 X_temp(bl_start_fit:end,:)], X.bl(bl_start_fit:end));
        bl_fit = b(1) + b(2)*x + b(3)*(x.^2) + b(4)*(x.^3);
        X.bl = [X.bl(1:bl_start_fit-1); bl_fit];
        fPET.conn.X.start_fit = bl_start_fit;
    end
    fPET.conn.X.bl = X.bl;

% each ROI separately fitted with 3rd order polynomial fitting
% data before fit is removed
elseif fpetbatch.conn.in.bl_type == 3
    if fpetbatch.conn.in.time == 1
        bl_start_fit = round(fpetbatch.conn.in.bl_start_fit/fpetbatch.conn.in.framelength);
    elseif fpetbatch.conn.in.time == 2
        bl_start_fit = fpetbatch.conn.in.bl_start_fit;
    end
    x = (bl_start_fit:numel(Y.h))';
    fPET.conn.X.bl = [x x.^2 x.^3];
    fPET.conn.X.motion.d_final = fPET.conn.X.motion.d_final(bl_start_fit:end,:);
    fPET.conn.X.add.d = fPET.conn.X.add.d(bl_start_fit:end,:);
    fPET.tvec = fPET.tvec(bl_start_fit:end);
    fPET.conn.X.start_fit = bl_start_fit;

% spatio-temporal filter (Monash)
elseif fpetbatch.conn.in.bl_type == 4
    % not yet implemented

% bandpass filter
elseif fpetbatch.conn.in.bl_type == 5
    % NOT yet fully tested, use at own risk
    if ~isfield(fpetbatch.conn.in.filter,'order') || isempty(fpetbatch.conn.in.filter.order)
        filter.order = fpet_defaults.conn.in.filter.order;
    else
        filter.order = round(fpetbatch.conn.in.filter.order/2);
    end
    if ~isfield(fpetbatch.conn.in.filter,'cutoff') || isempty(fpetbatch.conn.in.filter.cutoff)
        filter.cutoff = fpet_defaults.conn.in.filter.cutoff;
    else
        if fpetbatch.conn.in.time == 1
            filter.cutoff = 1/fpetbatch.conn.in.filter.cutoff;
        elseif fpetbatch.conn.in.time == 2
            filter.cutoff = 1/(fpetbatch.conn.in.filter.cutoff*fpetbatch.conn.in.framelength);
        end
    end
    filter.f_nyq = (1/fpetbatch.conn.in.framelength)/2;
    [filter.b, filter.a] = butter(filter.order, filter.cutoff/filter.f_nyq, 'bandpass');
    fPET.conn.filter = filter;
    
end
fPET.conn.bl_type = fpetbatch.conn.in.bl_type;



% save values
save(fullfile(fPET.dir.result, 'fPET_conn.mat'), 'fPET');
pn = fPET.dir.result;

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





