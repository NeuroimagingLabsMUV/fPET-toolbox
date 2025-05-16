function fpet_tlbx_conn_calc(Y, pn);
% fPET toolbox: connectivity calculations
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria

load(fullfile(pn,'fPET_conn.mat'));

% reshape
M.atlas.d_re = reshape(fPET.conn.M.atlas.d, numel(fPET.conn.M.atlas.d), 1);
Y.d_re = reshape(Y.d, numel(Y.d(:,:,:,1)), size(Y.d,4));

% for polynomial data before fit is removed
if fPET.conn.bl_type == 2 || fPET.conn.bl_type == 3
    Y.d_re = Y.d_re(:,fPET.conn.X.start_fit:end);
end

% remove baseline tracer uptake
R.rvxl_re = zeros(size(Y.d_re));
% average tac +/- 3rd order polynomial fitting
if fPET.conn.bl_type == 1 || fPET.conn.bl_type == 2
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
    
% for ROI fits, removal done below at ROI level
elseif fPET.conn.bl_type == 3
    R.rvxl_re = Y.d_re;

% spatio-temporal filter (Monash)
elseif fPET.conn.bl_type == 4
    % not yet implemented
%     for ind = 1:size(M.atlas.d_re,1)
%         if M.atlas.d_re(ind) ~= 0
%             tac = double(Y.d_re(ind,:));
%             if any(tac)
% 
%             end
%         end
%     end

% bandpass filter
elseif fPET.conn.bl_type == 5
    % NOT yet fully tested, use at own risk
    for ind = 1:size(M.atlas.d_re,1)
        if M.atlas.d_re(ind) ~= 0
            tac = double(Y.d_re(ind,:));
            if any(tac)
                R.rvxl_re(ind,:) = filtfilt(fPET.conn.fil.b, fPET.conn.fil.a, tac);
            end
        end
    end
end

% extract tacs for each roi
nr_roi = nonzeros(unique(M.atlas.d_re));
tac = zeros(numel(nr_roi),size(R.rvxl_re,2));
for ind = 1:numel(nr_roi)
    for ind_t = 1:size(R.rvxl_re,2)
        tac(ind,ind_t) = mean(R.rvxl_re(M.atlas.d_re==nr_roi(ind),ind_t));
    end
end

% regression against nuisance parameters
if fPET.conn.bl_type == 1 || fPET.conn.bl_type == 2
    R.rROI = tac;

% each ROI separately fitted with 3rd order polynomial fitting
elseif fPET.conn.bl_type == 3
    R.rROI = zeros(size(tac));
    X = [fPET.conn.X.bl fPET.conn.X.motion.d_final fPET.conn.X.add.d];
    for ind = 1:numel(nr_roi)
        [~,~,stats] = glmfit(X, tac(ind,:));
        R.rROI(ind,:) = stats.resid;
    end

elseif fPET.conn.bl_type == 4 || fPET.conn.bl_type == 5
    % NOT yet fully tested, use at own risk
    if ~isempty(fPET.conn.X.motion.d_final) || ~isempty(fPET.conn.X.add.d)
        R.rROI = zeros(size(tac));
        X = [fPET.conn.X.motion.d_final fPET.conn.X.add.d];
        for ind = 1:numel(nr_roi)
            [~,~,stats] = glmfit(X, tac(ind,:));
            R.rROI(ind,:) = stats.resid;
        end
    else
        R.rROI = tac;
    end
end

% calculate connectivity matrix
r = (corr(R.rROI', 'rows','complete'))';
z = 0.5 * log((1+r)./(1-r));

% save data
save(fullfile(fPET.dir.result, sprintf('Conn_bl%i.mat', fPET.conn.bl_type)), 'z');

fPET.conn.complete = 1;
save(fullfile(fPET.dir.result, 'fPET_conn.mat'), 'fPET');
disp('connectivity calculation complete.')


end




