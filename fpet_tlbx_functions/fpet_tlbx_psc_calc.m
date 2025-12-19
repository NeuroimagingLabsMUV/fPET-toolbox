function fpet_tlbx_psc_calc(pn);
% fPET toolbox: calculate percent signal change maps
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria

load(fullfile(pn,'fPET_glm.mat'));

% baseline
X.bl = fPET.glm.X.bl;
% probabilistic
if fPET.glm.X.bl_prob
    temp = which('fpet_tlbx_run');
    M.bl_prob.h = spm_vol(fullfile(temp(1:end-16),'fpet_data','prob','FDG_human_KPM.nii'));
    M.bl_prob.d = spm_read_vols(M.bl_prob.h);
    M.bl_prob.d(isinf(M.bl_prob.d)) = 0;
    M.bl_prob.d(isnan(M.bl_prob.d)) = 0;
    M.bl_prob.d_re = reshape(M.bl_prob.d, numel(M.bl_prob.d(:,:,:,1)), size(M.bl_prob.d,4));
end

% beta baseline
B.bl.h = spm_vol('b2_baseline.nii');
B.bl.d = spm_read_vols(B.bl.h);
B.bl.d(isinf(B.bl.d)) = NaN;
B.bl.d_re = reshape(B.bl.d, numel(B.bl.d(:,:,:)), 1);

% beta stimulation
for ind_s = 1:size(fPET.glm.X.stim.d,2)
    B.stim.h = spm_vol(sprintf('b%i_%s.nii', ind_s+2, fPET.glm.X.name{ind_s+2}));
    B.stim.d = spm_read_vols(B.stim.h);
    B.stim.d(isinf(B.stim.d)) = NaN;
    B.stim.d_re = reshape(B.stim.d, numel(B.stim.d(:,:,:)), 1);
    
    % compute percent signal change
    R.stim.d_re = zeros(size(B.bl.d_re));
    for ind_v = 1:size(B.bl.d_re,1)
        if (B.bl.d_re(ind_v))
            if fPET.glm.X.bl_prob
                bl_temp = sum(X.bl.*M.bl_prob.d_re(ind_v,:),2);
                X.bl_temp = bl_temp * B.bl.d_re(ind_v);
            else
                X.bl_temp = X.bl * B.bl.d_re(ind_v);
            end

            % first order polynomial from 1/3 of scan
            % scale x in units of minutes, i.e. slope in kBq/min (matching task regressor)
            x = (fPET.tvec/60)';
            if fPET.Y.incomplete == 1
                [~,t_start] = min(abs(x - x(end)/3));
            else
                t_start = round(numel(X.bl_temp)/3);
            end
            coeff = polyfit(x(t_start:end), X.bl_temp(t_start:end), 1);
            
            R.stim.d_re(ind_v) = B.stim.d_re(ind_v)/coeff(1)*100;
        end
    end
    
    % save data
    R.stim.h = B.stim.h;
    R.stim.h.dt(1) = 16;        % single
    
    R.stim.h.fname = fullfile(fPET.dir.result, sprintf('b%i_%s_PSC.nii', ind_s+2, fPET.glm.X.name{ind_s+2}));
    spm_write_vol(R.stim.h, reshape(R.stim.d_re, R.stim.h.dim));
    
end

fPET.psc.complete = 1;
save(fullfile(fPET.dir.result, 'fPET_glm.mat'), 'fPET');
disp('percent signal change complete.')

        
end
