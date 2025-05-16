function fpet_tlbx_ica_calc(pn);
% fPET toolbox: ica calculations
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria

load(fullfile(pn,'fPET_ica.mat'));

% reshape
M.calc = fPET.ica.M.calc;
M.calc.d_re = reshape(M.calc.d, numel(M.calc.d), 1);

% individual subject
Y_d_all_re = [];
for ind = 1:numel(fPET.ica.files)
    % data
    Y = fpet_tlbx_load4d(fPET.ica.files{ind}, fPET.ica.X.rem.start, fPET.ica.X.rem.end);
    fPET.Y(ind).h = Y.h;
    fPET.Y(ind).h_orig = Y.h_orig;
    
    Y.d_re = reshape(Y.d, numel(Y.d(:,:,:,1)), size(Y.d,4));
    Y.d_re = Y.d_re(M.calc.d_re==1,:);
    
    % WB normalization [Haas/Bravo 2024]
    Y.d_re = Y.d_re./nanmean(Y.d_re);
    Y.d_re = zscore(Y.d_re, 0, 2);
    % dimensionality reduction [Li 2020]
    if fPET.ica.pca == 1
        Y.d_re = Y.d_re';
        [coeff, sco] = pca(Y.d_re, 'NumComponents', fPET.ica.pc);
        Y.d_pca_re = (coeff * (coeff' * Y.d_re'))';
    else
        Y.d_pca_re = Y.d_re';
    end
    Y.d_pca_re = zscore(Y.d_pca_re, 0, 2);
    Y_d_all_re = [Y_d_all_re; Y.d_pca_re];
end

% group
if numel(fPET.ica.files) > 1
    % dimensionality reduction over entire group [Li 2020]
    if fPET.ica.pca == 1
        coeff = pca(Y_d_all_re', 'NumComponents', fPET.ica.pc);
        Y_d_all_pca_re = coeff * (coeff' * Y_d_all_re);
    else
        Y_d_all_pca_re = Y_d_all_re;
    end
    Y_d_all_pca_re = zscore(Y_d_all_pca_re, 0, 2);
    prefix = 'gic'; % group ica prefix
else
    Y_d_all_pca_re = Y_d_all_re;
    prefix = 'ic'; % single subject prefix
end

% perform fastICA on either group or individual level
for ind = 1:10
    [R.d_re(ind).temp, R.d_re(ind).mix_matr, R.d_re(ind).sep_matr] = fastica(Y_d_all_pca_re, 'numOfIC',fPET.ica.ic, 'approach','symm', 'g','tanh', 'stabilization','on', 'verbose','off');
    kt(:,ind) = kurtosis(R.d_re(ind).temp,0,2);
end
[kt_sort, kt_sind] = sort(kt, 'descend');
[~,ind_max] = max(mean(kt_sort(1:round(size(kt_sort,1)/2),:)));
R.d_final_re = zeros(fPET.ica.ic, length(M.calc.d_re));
R.d_final_re(:,M.calc.d_re==1) = R.d_re(ind_max).temp(kt_sind(:,ind_max),:);

fPET.ica.R.kt_sort = kt_sort(:,ind_max);
fPET.ica.R.mix_matr = R.d_re(ind_max).mix_matr;
fPET.ica.R.sep_matr = R.d_re(ind_max).sep_matr;

% save data
R.h_temp = fPET.Y(1).h_orig(1);
R.h_temp.dt(1) = 16;        % single
for ind = 1 : size(R.d_final_re,1)
    R.h_temp.fname = fullfile(fPET.dir.result, [prefix num2str(ind) '.nii']);
%     R.d_final = reshape(zscore(R.d_final_re(ind,:)), size(Y.d,1:3));
    R.d_final = reshape(zscore(R.d_final_re(ind,:)), [size(Y.d,1) size(Y.d,2) size(Y.d,3)]);
    spm_write_vol(R.h_temp,R.d_final);
end

fPET.ica.complete = 1;
save(fullfile(fPET.dir.result, 'fPET_ica.mat'), 'fPET');
disp('ica calculation complete.')

end



