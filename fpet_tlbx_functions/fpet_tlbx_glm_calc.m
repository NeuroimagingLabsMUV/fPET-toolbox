function fpet_tlbx_glm_calc(Y, fpet_param);
% fPET toolbox: glm calculations
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria

load(fullfile(fpet_param.pn,'fPET_glm.mat'));

% regressors
X_all = fPET.glm.X.all;

% reshape
M.calc = fPET.glm.M.calc;
M.calc.d_re = reshape(M.calc.d, numel(M.calc.d), 1);
Y.d_re = reshape(Y.d, numel(Y.d(:,:,:,1)), size(Y.d,4));
if fPET.glm.X.bl_prob
    M.bl_prob.d_re = reshape(fpet_param.M.bl_prob.d, numel(fpet_param.M.bl_prob.d(:,:,:,1)), size(fpet_param.M.bl_prob.d,4));
end

% initialize results
R.b_re = zeros(size(Y.d_re,1), size(X_all,2)+1);
R.t_re = zeros(size(Y.d_re,1), size(X_all,2)+1);
R.r_re = zeros(size(Y.d_re,1), 1);

for ind = 1:size(M.calc.d_re,1)
    if M.calc.d_re(ind)
        tac = double(Y.d_re(ind,:));
        if any(tac)
            if fPET.glm.fil.apply == 1
                if fPET.Y.incomplete == 1
                    % temporarily interpolate missing data for proper filter function
                    tvec_temp = fPET.tvec;
                    if (fPET.glm.X.incomplete.start(1) ~= 1)
                        tvec_temp(1) = [];
                    end
                    ind_miss = find(diff(tvec_temp)>(fPET.framelength*1.5));
                    clear x_orig tac_orig ind_temp y_temp;
                    x_orig{1} = tvec_temp(1:ind_miss(1));
                    tac_orig{1} = tac(1:ind_miss(1));
                    for ind2 = 1:numel(ind_miss)-1
                        x_orig{ind2+1} = tvec_temp(ind_miss(ind2)+1:ind_miss(ind2+1));
                        tac_orig{ind2+1} = tac(ind_miss(ind2)+1:ind_miss(ind2+1));
                    end
                    x_orig{ind2+2} = tvec_temp(ind_miss(end)+1:end);
                    tac_orig{ind2+2} = tac(ind_miss(end)+1:end);
                    n_add = 0;
                    for ind2 = 1:numel(ind_miss)
                        x_temp = tvec_temp(ind_miss(ind2))+fPET.framelength:fPET.framelength:tvec_temp(ind_miss(ind2)+1);
                        if x_temp(end) == x_orig{ind2+1}(1)
                            x_temp(end) = [];
                        end
                        ind_temp{ind2} = (ind_miss(ind2)+1:ind_miss(ind2)+numel(x_temp)) + n_add;
                        n_add = n_add + numel(ind_temp{ind2});
                        y_temp{ind2} = interp1(tvec_temp(ind_miss(ind2):ind_miss(ind2)+1), tac(ind_miss(ind2):ind_miss(ind2)+1), x_temp);
                    end
                    tac_temp = [];
                    for ind2 = 1:numel(ind_miss)
                        tac_temp = [tac_temp tac_orig{ind2} y_temp{ind2}];
                    end
                    tac_temp = [tac_temp tac_orig{ind2+1}];
                    tac = filtfilt(fPET.glm.fil.b, fPET.glm.fil.a, tac_temp);
                    tac(cell2mat(ind_temp)) = [];
                else
                    tac = filtfilt(fPET.glm.fil.b, fPET.glm.fil.a, tac);
                end
            end
            % adding anchor point for incomplete data (advanced)
            if (fPET.Y.incomplete == 1) && (fPET.glm.X.incomplete.start(1) ~= 1) && (fPET.glm.X.incomplete.no_anchor == 0)
                tac = [0 tac];
            end
            if fPET.glm.X.bl_prob
                % probabilistic baseline
                bl_temp = sum(fPET.glm.X.bl.*M.bl_prob.d_re(ind,:),2);
                [b,dev,stats] = glmfit([bl_temp X_all(:,2:end)], tac, '', 'weights',fPET.glm.weight);
            else
                [b,dev,stats] = glmfit(X_all, tac, '', 'weights',fPET.glm.weight);
            end
            for ind2 = 1:size(X_all,2)+1
                R.b_re(ind,ind2) = b(ind2);
                R.t_re(ind,ind2) = stats.t(ind2);
            end
            R.r_re(ind,1) = dev;
        end
    end
end

% save data
R.h_temp = Y.h_orig(1);
R.h_temp.dt(1) = 16;        % single
for ind = 1:size(R.b_re,2)
    R.h_temp.fname = fullfile(fPET.dir.result, sprintf('b%i_%s.nii', ind, fPET.glm.X.name{ind}));
    spm_write_vol(R.h_temp, reshape(R.b_re(:,ind), R.h_temp.dim));
end
for ind = 1:size(R.t_re,2)
    R.h_temp.fname = fullfile(fPET.dir.result, sprintf('t%i_%s.nii', ind, fPET.glm.X.name{ind}));
    spm_write_vol(R.h_temp, reshape(R.t_re(:,ind), R.h_temp.dim));
end
R.h_temp.fname = fullfile(fPET.dir.result, 'residuals.nii');
spm_write_vol(R.h_temp, reshape(R.r_re, R.h_temp.dim));
R.h_temp.fname = fullfile(fPET.dir.result, 'mask_bl.nii');
spm_write_vol(R.h_temp, fPET.glm.M.bl.d);

fPET.glm.complete = 1;
save(fullfile(fPET.dir.result, 'fPET_glm.mat'), 'fPET');
disp('glm calculation complete.')

end

