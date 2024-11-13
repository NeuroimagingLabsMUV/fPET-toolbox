function fpet_tlbx_quant_calc(pn);
% fPET toolbox: calculate quantitative maps
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria

load(fullfile(pn,'fPET_glm.mat'));
nr_regr_stim = size(fPET.glm.X.stim.d,2);

% regressor baseline
X.bl = fPET.glm.X.bl;
% remove anchor point of incomplete data for quantification (advanced)
if (fPET.Y.incomplete == 1) && (fPET.glm.X.incomplete.start(1) ~= 1)
    X.bl(1) = [];
end
% regressors task, scale regressor to slope of 1 kBq/min
X.stim = cumsum(ones(size(X.bl)))*fPET.framelength/60;

% beta baseline
B.bl.h = spm_vol('b2_baseline.nii');
B.bl.d = spm_read_vols(B.bl.h);
B.bl.d(isinf(B.bl.d)) = NaN;
B.bl.d_re(:,1) = reshape(B.bl.d, numel(B.bl.d(:,:,:)), 1);

% beta task
for ind = 1:nr_regr_stim
    B.stim.h = spm_vol(sprintf('b%i_%s.nii', ind+2, fPET.glm.X.name{ind+2}));
    B.stim.d = spm_read_vols(B.stim.h);
    B.stim.d(isinf(B.stim.d)) = NaN;
    B.stim.d_re(:,ind) = reshape(B.stim.d, numel(B.stim.d(:,:,:)), 1);
end

% calculation
for ind = 1:nr_regr_stim+1
    R.d_re = zeros(size(B.bl.d_re));
    if ind == 1
        X_temp = X.bl;
        B_temp = B.bl.d_re;
        R.h = B.bl.h;
        R.h.fname = fullfile(fPET.dir.result, 'b2_baseline_Ki.nii');
    else
        X_temp = X.stim;
        B_temp = B.stim.d_re(:,ind-1);
        R.h = B.stim.h;
        R.h.fname = fullfile(fPET.dir.result, sprintf('b%i_%s_Ki.nii', ind+1, fPET.glm.X.name{ind+1}));
    end
    for ind_v = 1:size(B_temp,1)
        if (B_temp(ind_v))
            tac = X_temp * B_temp(ind_v);
            % correct for vb
            tac = (tac-fPET.quant.vb*fPET.quant.wb.d_int)/(1-fPET.quant.vb);
            % Patlak plot
            y = tac./fPET.quant.p.d_int;
            % full integral despite incomplete data
            if fPET.Y.incomplete == 1
                x = (cumsum(fPET.quant.p.d_int_compl)*fPET.framelength/60)./fPET.quant.p.d_int_compl;
                tstar = round(length(x)*fPET.quant.tstar);
                if fPET.glm.X.incomplete.start(1) ~= 1
                    ind_rem = 1:(fPET.glm.X.incomplete.start(1)-1);
                else
                    ind_rem = [];
                end
                for ind2 = 2:numel(fPET.glm.X.incomplete.start)
                    ind_rem = [ind_rem (fPET.glm.X.incomplete.end(ind2-1)+1):(fPET.glm.X.incomplete.start(ind2)-1)];
                end
                x(ind_rem) = [];
                tstar = tstar - ind_rem(find(ind_rem<tstar,1,'last'));
            else
                x = (cumsum(fPET.quant.p.d_int)*fPET.framelength/60)./fPET.quant.p.d_int;
                tstar = round(length(x)*fPET.quant.tstar);
            end
            coeff = polyfit(x(tstar:end), y(tstar:end), 1);
            R.d_re(ind_v) = coeff(1);
        end
    end

    % save Ki
    spm_write_vol(R.h, reshape(R.d_re, R.h.dim));

    % calc CMRGlu
    if ~isnan(fPET.quant.bloodlvl)
        R.d_re2 = R.d_re*fPET.quant.bloodlvl/fPET.quant.lc * 100/1.04;  % assumed tissue density 1.04 g/ml
        R.h.fname = sprintf('%s_CMRGlu.nii', R.h.fname(1:end-7));
        spm_write_vol(R.h, reshape(R.d_re2, R.h.dim));
    end
    
end

fPET.quant.complete = 1;
save(fullfile(fPET.dir.result, 'fPET_glm.mat'), 'fPET');
disp('quantification complete.')


end

