function fpet_tlbx_conn_calc(Y, pn)
% fPET toolbox: connectivity calculations
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria

load(fullfile(pn,'fPET_conn.mat'));
R.name{1} = 'cMC_bl1';
R.name{2} = 'cMC_bl2';
R.name{3} = 'cMC_bl3';
R.name{4} = 'cMC_st';
R.name{5} = 'cMC_cc';
R.name{6} = 'cMC_bn';
R.name{7} = 'eMC';

% reshape
M.atlas.d_re = round(reshape(fPET.conn.M.atlas.d, numel(fPET.conn.M.atlas.d), 1));
Y.d_re = reshape(Y.d, [], size(Y.d,4));

% for polynomial data before fit is removed
if fPET.conn.type == 2 || fPET.conn.type == 3
    Y.d_re = Y.d_re(:,fPET.conn.X.start_fit:end);
end

% remove baseline tracer uptake
R.rvxl_re = zeros(size(Y.d_re));
% average tac +/- 3rd order polynomial fitting
if fPET.conn.type == 1 || fPET.conn.type == 2
	X = [fPET.conn.X.bl fPET.conn.X.motion.d_final fPET.conn.X.add.d];
	for ind = 1:size(M.atlas.d_re,1)
		if M.atlas.d_re(ind) ~= 0
			tac = double(Y.d_re(ind,:));
			if any(tac)
				[~,~,stats] = glmfit(X, tac);
				R.rvxl_re(ind,:) = stats.resid;
			end
		end
	end
        
% for ROI fits, removal done below at ROI level for bl3, euclidean distance
% and baseline normalization
elseif any(fPET.conn.type==[3 6 7])
    R.rvxl_re = Y.d_re;

% spatio-temporal filter (Monash)
elseif fPET.conn.type == 4
    t_width = 7;
    s_width = 7;
    
    t_se = fspecial('gaussian', [1 t_width], fPET.conn.fil.sig_t);
    t_se = reshape(t_se, [1 1 1 t_width]); % make it 4D
    s_se = fspecial3('gaussian', s_width, fPET.conn.fil.sig_s);
    se = convn(s_se, t_se);
    se(:,:,:,ceil(t_width/2)) = 0;
    se = 2 .* se ./ sum(se, 'all');
    se(:,:,:,ceil(t_width/2)+1:end) = -se(:,:,:,ceil(t_width/2)+1:end);
    stD = convn(Y.d, se, 'same');
    
    stD(:,:,:,1:floor(t_width/2)) = stD(:,:,:,ceil(t_width/2) * ones(1, floor(t_width/2)));
    stD(:,:,:,(size(stD,4)-floor(t_width/2)+1):end) = ...
	stD(:,:,:,(size(stD,4)-floor(t_width/2)) * ones(1, floor(t_width/2)));
    
    R.rvxl_re = reshape(stD, size(stD,1) * size(stD,2) * size(stD,3), size(stD,4));

% CompCor filter
elseif fPET.conn.type == 5
    if fPET.conn.M.nui_t == -1
        fPET.conn.M.tissue.d = (fPET.conn.M.csf.d + fPET.conn.M.wm.d);
    else
        fPET.conn.M.tissue.d = (fPET.conn.M.csf.d + fPET.conn.M.wm.d) > fPET.conn.M.nui_t;
    end
    fPET.conn.M.tissue.d_re = fPET.conn.M.tissue.d(:)';
    [~, C, ~, ~, var_exp] = pca(zscore(Y.Y_norm.d_re(:, fPET.conn.M.tissue.d_re)));
    nComp = findElbow(var_exp);
    C = zscore(C(:, 1:nComp));

    RP2   = fPET.conn.X.motion.d .^ 2;                        
    RPlag = [zeros(1, 6); fPET.conn.X.motion.d(1:end-1,:)];   
    RPlag2 = RPlag .^ 2;               
    F24 = [fPET.conn.X.motion.d RPlag RP2 RPlag2];
    RP2 = []; RPlag = []; RPlag2 = [];
    if any(fPET.conn.fil.cutoff ~= -1)
        %create BP matrix
        Fs = 1 / fPET.framelength;
        df = Fs / size(Y.Y_norm.d,4);
        f = df:df:Fs/2;
        freqs = f(f < fPET.conn.fil.cutoff(1) | f > fPET.conn.fil.cutoff(2));
        t = (0:fPET.framelength:(size(Y.Y_norm.d,4) - 1) * fPET.framelength)';
        fPET.conn.fil.filt_matrix = zeros(size(Y.Y_norm.d,4), 2 * length(freqs));
        fPET.conn.fil.filt_matrix(:, 1:end/2)       = cos(2 * pi * t * freqs);
        fPET.conn.fil.filt_matrix(:, end/2 + 1:end) = sin(2 * pi * t * freqs);
    
        cX = [C fPET.conn.fil.filt_matrix F24 fPET.conn.X.add.d  ones(size(C,1),1)];
    else
        cX = [C F24 fPET.conn.X.add.d  ones(size(C,1),1)];
    end
    Y.Y_norm = [];
    Y.d_re = Y.d_re';
    R.rvxl_re = zeros(size(Y.d_re), 'single');
    B = cX \ Y.d_re(:,fPET.conn.M.mask_calc.d_re);
    R.rvxl_re(:,fPET.conn.M.mask_calc.d_re) = Y.d_re(:,fPET.conn.M.mask_calc.d_re) - cX(:,1:end-1) * B(1:end-1,:);
    R.rvxl_re = R.rvxl_re';
    Y.d_re = []; Y.d = []; B = [];
end

% extract tacs for each roi
nr_roi = nonzeros(unique(M.atlas.d_re));
tac = zeros(numel(nr_roi),size(R.rvxl_re,2));
for ind = 1:numel(nr_roi)
	tac(ind,:) = mean(R.rvxl_re(M.atlas.d_re==nr_roi(ind),:),1, 'omitnan');
end
R.rvxl_re = [];

% regression against nuisance parameters
if fPET.conn.type == 1 || fPET.conn.type == 2
    R.rROI = tac;
	
% each ROI separately fitted with 3rd order polynomial fitting
elseif fPET.conn.type == 3
    R.rROI = zeros(size(tac));
    X = [fPET.conn.X.bl fPET.conn.X.motion.d_final fPET.conn.X.add.d];
    for ind = 1:numel(nr_roi)
        [~,~,stats] = glmfit(X, tac(ind,:));
        R.rROI(ind,:) = stats.resid;
    end

% spatio-temporal filter (Monash)
elseif fPET.conn.type == 4
	X = [fPET.conn.X.motion.d_final fPET.conn.X.add.d];
	R.rROI = tac;
	
elseif fPET.conn.type == 5
    R.rROI = tac;

elseif fPET.conn.type == 6
    X = [fPET.conn.X.motion.d_final fPET.conn.X.add.d];
    gSig = mean(Y.d_re(M.atlas.d_re~=0,:), 1);
    R.rROI = tac ./ gSig;
    
elseif fPET.conn.type == 7
    R.rROI = atanh(1-rescale(pdist2(tac, tac)));
    R.rROI(isinf(R.rROI) | isnan(R.rROI)) = 0;
    R.rROI = rescale(R.rROI);
end
tac = [];

% calculate connectivity matrix
if any(fPET.conn.type==[1 2 3 5])
	r = corr(R.rROI', 'rows','complete');
elseif any(fPET.conn.type==[4 6])
	if ~isempty(X)
		r = partialcorr(R.rROI', X, 'rows','complete');
	else
		r = corr(R.rROI', 'rows','complete');
	end
else
	r = R.rROI;
end

z = 0.5 * log((1+r)./(1-r));

% save data
save(fullfile(fPET.dir.result, sprintf('Conn_%s.mat', R.name{fPET.conn.type})), 'z', 'r');

fPET.conn.complete = 1;
save(fullfile(fPET.dir.result, 'fPET_conn.mat'), 'fPET');
disp('connectivity calculation complete.')
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
