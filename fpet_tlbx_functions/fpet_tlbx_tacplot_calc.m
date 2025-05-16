function tac = fpet_tlbx_tacplot_calc(fpetbatch);
% fPET toolbox: calculations to plot task-specific activation
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria

% glm
if fpetbatch.tacplot.in.type == 1
    nr_subj = numel(fpetbatch.tacplot.in.dir);
    fprintf('plotting task tacs of %i subjects.\n', nr_subj);

    % mask of task effects
    M.plot.h = spm_vol(fpetbatch.tacplot.in.mask);
    M.plot.d = spm_read_vols(M.plot.h);
    M.plot.d(isinf(M.plot.d)) = 0;
    M.plot.d(isnan(M.plot.d)) = 0;
    M.plot.d(M.plot.d~=0) = 1;

    for ind = 1:nr_subj
        load(fpetbatch.tacplot.in.dir{ind});
        Y.d = spm_read_vols(fPET.Y.h);
        Y.d(isinf(Y.d)) = NaN;

        % extract tac
        tac_temp = zeros(size(Y.d,4),1);
        for ind2 = 1:size(Y.d,4)
            temp = Y.d(:,:,:,ind2);
            tac_temp(ind2,1) = nanmean(temp(M.plot.d==1));
        end
        tac_temp(isnan(tac_temp)) = 0;

        if any(tac_temp)
            % apply filter
            if fPET.glm.fil.apply == 1
                tac_temp = filtfilt(fPET.glm.fil.b, fPET.glm.fil.a, tac_temp);
            end
            % adding anchor point for incommplete data (advanced)
            if (fPET.Y.incomplete == 1) && (fPET.glm.X.incomplete.start(1) ~= 1)
                tac_temp = [0; tac_temp];
            end
            % glm
            X_all = [fPET.glm.X.bl fPET.glm.X.stim.d fPET.glm.X.add.d fPET.glm.X.motion.d_final];
            b = glmfit(X_all, tac_temp, '', 'weights',fPET.glm.weight);
            regr = fpetbatch.tacplot.in.regr - 1;
            tac.raw.d(ind,:) = tac_temp;
            for ind2 = 1:numel(regr)
                % remove regressors of non-interest
                tac_temp = tac.raw.d(ind,:);
                X_temp = X_all;
                b_temp = b(2:end);
                tac.spec(ind2).X(ind,:) = X_temp(:,regr(ind2));
                tac.spec(ind2).b(ind) = b_temp(regr(ind2));
                X_temp(:,regr(ind2)) = [];
                b_temp(regr(ind2)) = [];
                tac.spec(ind2).d(ind,:) = tac_temp' - b(1) - sum(X_temp.*b_temp',2);
                tac.spec(ind2).name = fPET.glm.X.name{regr(ind2)+1};
            end
        else
            error('no data found within mask.');
        end

    end

    % plotting individual tacs
    if fpetbatch.tacplot.in.indiv == 1
        for ind = 1:nr_subj
            % raw tac
            if fpetbatch.tacplot.in.raw
                figure,plot(fPET.tvec, tac.raw.d(ind,:), 'LineWidth',2), title(sprintf('Subject %i, TAC raw', ind))
            end
            % stimulation-specific tac
            for ind2 = 1:numel(regr)
                figure,hold on
                plot(fPET.tvec, tac.spec(ind2).X(ind,:)*tac.spec(ind2).b(ind), 'g--', 'LineWidth',2)
                plot(fPET.tvec, tac.spec(ind2).d(ind,:), 'k', 'LineWidth',2)
                title(sprintf('Subject %i, TAC %s', ind, tac.spec(ind2).name))
                hold off
            end
        end
    end

    % plotting average tac
    if (fpetbatch.tacplot.in.average == 1) && (nr_subj > 1)
        % raw tac
        if fpetbatch.tacplot.in.raw
            figure,plot(fPET.tvec, mean(tac.raw.d), 'LineWidth',2), title('Average, TAC raw')
        end
        % stimulation-specific tac
        for ind2 = 1:numel(regr)
            figure,hold on
            plot(fPET.tvec, mean(tac.spec(ind2).X)*mean(tac.spec(ind2).b), '--', 'Color',[60 210 91]/255, 'LineWidth',2)
            plot(fPET.tvec, mean(tac.spec(ind2).d), 'k', 'LineWidth',2)
            title(sprintf('Average, TAC %s', tac.spec(ind2).name))
            hold off
        end
    end

% ica
elseif fpetbatch.tacplot.in.type == 2
    load(fpetbatch.tacplot.in.dir{1,1});

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
        % dimensionality reduction over entire group
        if fPET.ica.pca == 1
            coeff = pca(Y_d_all_re', 'NumComponents', fPET.ica.pc);
            Y_d_all_pca_re = coeff * (coeff' * Y_d_all_re);
        else
            Y_d_all_pca_re = Y_d_all_re;
        end
        Y_d_all_pca_re = zscore(Y_d_all_pca_re, 0, 2);
    else
        Y_d_all_pca_re = Y_d_all_re;
    end

    % mask of task effects
    M.plot.h = spm_vol(fpetbatch.tacplot.in.mask);
    M.plot.d = spm_read_vols(M.plot.h);
    M.plot.d(isinf(M.plot.d)) = 0;
    M.plot.d(isnan(M.plot.d)) = 0;
    M.plot.d(M.plot.d~=0) = 1;
    M.plot.d_re = reshape(M.plot.d, numel(M.plot.d), 1);
    M.plot.d_re = M.plot.d_re(M.calc.d_re==1,:);
    
    % extract tac, average, apply separation matrix 
    for ind_ic = 1:numel(fpetbatch.tacplot.in.ic_nr)
        tac_all = Y_d_all_pca_re(:,M.plot.d_re==1);
        tac_all = mean(tac_all,2);
%         tac_all = tac_all.*(fPET.ica.R.sep_matr(fpetbatch.tacplot.in.ic_nr(ind_ic),:)');
        nr_frames = zeros(numel(fPET.Y),1);
        for ind = 1:numel(fPET.Y)
            nr_frames(ind) = numel(fPET.Y(ind).h);
        end
        tac = NaN(numel(fPET.Y), max(nr_frames));
        tac(1,1:nr_frames(1)) = tac_all(1:nr_frames(1));
        for ind = 2:numel(fPET.Y)
            tac(ind,1:nr_frames(ind)) = tac_all((sum(nr_frames(1:ind-1))+1):sum(nr_frames(1:ind)));
        end
        figure
        tvec = (1:size(tac,2))*fpetbatch.tacplot.in.framelength - fpetbatch.tacplot.in.framelength/2;
        plot(tvec, nanmean(tac), 'k', 'LineWidth',2)
        title(sprintf('Average TAC of IC %i', fpetbatch.tacplot.in.ic_nr(ind_ic)));
    end
end


end


