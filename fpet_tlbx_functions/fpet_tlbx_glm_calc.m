function fpet_tlbx_glm_calc(Y, pn);
% fPET toolbox: glm calculations
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria

load(fullfile(pn,'fPET_glm.mat'));

% regressors
X_all = fPET.glm.X.all;

% reshape
M.calc = fPET.glm.M.calc;
M.calc.d_re = reshape(M.calc.d, numel(M.calc.d), 1);
Y.d_re = reshape(Y.d, numel(Y.d(:,:,:,1)), size(Y.d,4));

% initialize results
R.b_re = zeros(size(Y.d_re,1), size(X_all,2)+1);
R.t_re = zeros(size(Y.d_re,1), size(X_all,2)+1);
R.r_re = zeros(size(Y.d_re,1), 1);

for ind = 1:size(M.calc.d_re,1)
    if M.calc.d_re(ind)
        tac = double(Y.d_re(ind,:));
        if any(tac)
            if fPET.glm.filter.apply == 1
                tac = filtfilt(fPET.glm.filter.b, fPET.glm.filter.a, tac);
            end
            % adding anchor point for incomplete data (advanced)
            if (fPET.Y.incomplete == 1) && (fPET.glm.X.incomplete.start(1) ~= 1)
                tac = [0 tac];
            end
            [b,dev,stats] = glmfit(X_all, tac, '', 'weights',fPET.glm.weight);
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

fPET.glm.complete = 1;
save(fullfile(fPET.dir.result, 'fPET_glm.mat'), 'fPET');
disp('glm calculation complete.')

end

