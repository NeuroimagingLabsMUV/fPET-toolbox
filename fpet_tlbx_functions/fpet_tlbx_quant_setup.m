function pn = fpet_tlbx_quant_setup(fpetbatch);
% fPET toolbox: set default values for quantification
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria

% load defaults
fpet_defaults = fpet_tlbx_defaults();

% result directory
if isfield(fpetbatch.dir,'result')
    pn = fpetbatch.dir.result;
else
    pn = pwd;
end
cd(pn);

load(fullfile(pn,'fPET_glm.mat'));

% process input, set defaults if undefined

% time vector
x = fPET.tvec;
% remove anchor point of incomplete data for quantification (advanced)
if fPET.Y.incomplete == 1
    x_compl = (fPET.framelength-fPET.framelength/2):fPET.framelength:fPET.tvec(end);
    if fPET.glm.X.incomplete.start(1) ~= 1
        x(1) = [];
    end
end

% vb
if isfield(fpetbatch.quant.in,'vb') && ~isempty(fpetbatch.quant.in.vb)
    fPET.quant.vb = fpetbatch.quant.in.vb;
else
    fPET.quant.vb = fpet_defaults.quant.in.vb;
end

% whole blood data
if isfield(fpetbatch.quant.in,'wb') && ~isempty(fpetbatch.quant.in.wb)
    B.wb.h = fpetbatch.quant.in.wb;
    temp = importdata(B.wb.h);
    if isstruct (temp)
        B.wb.d = temp.data;
        B.wb.d_head = temp.textdata;
    else
        B.wb.d = temp;
    end
    B.wb.d(isnan(B.wb.d(:,2)),:) = [];
    if fpetbatch.quant.in.time == 2
        B.wb.d(:,1) = B.wb.d(:,1) * 60;
    end
    B.wb.d = [0 0; B.wb.d];
    B.wb.d_int = interp1(B.wb.d(:,1),B.wb.d(:,2),x,'linear','extrap');
    B.wb.d_int = B.wb.d_int';
    % complete blood data for incomplete data (advanced)
    if fPET.Y.incomplete == 1
        B.wb.d_int_compl = interp1(B.wb.d(:,1),B.wb.d(:,2),x_compl,'linear','extrap');
        B.wb.d_int_compl = B.wb.d_int_compl';
    end
    fPET.quant.wb = B.wb;
else
    fPET.quant.wb.d_int = NaN;
end

% plasma data
if isfield(fpetbatch.quant.in,'plasma') && ~isempty(fpetbatch.quant.in.plasma)
    B.p.h = fpetbatch.quant.in.p;
    temp = importdata(B.p.h);
    if isstruct (temp)
        B.p.d = temp.data;
        B.p.d_head = temp.textdata;
    else
        B.p.d = temp;
    end
    B.p.d(isnan(B.p.d(:,2)),:) = [];
    if fpetbatch.quant.in.time == 2
        B.p.d(:,1) = B.p.d(:,1) * 60;
    end
    B.p.d = [0 0; B.p.d];
    B.p.d_int = interp1(B.p.d(:,1),B.p.d(:,2),x,'linear','extrap');
    B.p.d_int = B.p.d_int';
    % complete blood data for incomplete data (advanced)
    if fPET.Y.incomplete == 1
        B.p.d_int_compl = interp1(B.p.d(:,1),B.p.d(:,2),x_compl,'linear','extrap');
        B.p.d_int_compl = B.p.d_int_compl';
    end
    fPET.quant.p = B.p;
else
    fPET.quant.p.d_int = NaN;
end

% plasma/whole blood ratio
if isfield(fpetbatch.quant.in,'pwbr') && ~isempty(fpetbatch.quant.in.pwbr)
    B.pwbr.h = fpetbatch.quant.in.pwbr;
    temp = importdata(B.pwbr.h);
    if isstruct (temp)
        B.pwbr.d = temp.data;
        B.pwbr.d_head = temp.textdata;
    else
        B.pwbr.d = temp;
    end
    B.pwbr.d(isnan(B.pwbr.d(:,2)),:) = [];
    if fpetbatch.quant.in.time == 2
        B.pwbr.d(:,1) = B.pwbr.d(:,1) * 60;
    end

    if isfield(fpetbatch.quant.in,'pwbr_fit') && ~isempty(fpetbatch.quant.in.pwbr_fit)
        fPET.quant.pwbr_fit = fpetbatch.quant.in.pwbr_fit;
    else
        fPET.quant.pwbr_fit = fpet_defaults.quant.in.pwbr_fit;
    end
    
    if fPET.quant.pwbr_fit == 1
        B.pwbr.d_fit = nanmean(B.pwbr.d(:,2));
        % complete blood data for incomplete data (advanced)
        if fPET.Y.incomplete == 1
            B.pwbr.d_fit_compl = B.pwbr.d_fit;
        end
    elseif fPET.quant.pwbr_fit == 2
        coeff = polyfit(B.pwbr.d(:,1), B.pwbr.d(:,2), 1);
        B.pwbr.d_fit = (x*coeff(1) + coeff(2))';
        % complete blood data for incomplete data (advanced)
        if fPET.Y.incomplete == 1
            B.pwbr.d_fit_compl = (x_compl*coeff(1) + coeff(2))';
        end
    end
    fPET.quant.pwbr = B.pwbr;
else
    fPET.quant.pwbr.d_fit = NaN;
end

% parent fraction
if isfield(fpetbatch.quant.in,'parent') && ~isempty(fpetbatch.quant.in.parent)
    B.parent.h = fpetbatch.quant.in.parent;
    temp = importdata(B.parent.h);
    if isstruct (temp)
        B.parent.d = temp.data;
        B.parent.d_head = temp.textdata;
    else
        B.parent.d = temp;
    end
    B.parent.d(isnan(B.parent.d(:,2)),:) = [];
    if fpetbatch.quant.in.time == 2
        B.parent.d(:,1) = B.parent.d(:,1) * 60;
    end
    B.parent.d_int = interp1(B.parent.d(:,1),B.parent.d(:,2),x,'linear','extrap');
    B.parent.d_int = B.parent.d_int';
    % complete blood data for incomplete data (advanced)
    if fPET.Y.incomplete == 1
        B.parent.d_int_compl = interp1(B.parent.d(:,1),B.parent.d(:,2),x_compl,'linear','extrap');
        B.parent.d_int_compl = B.parent.d_int_compl';
    end
    fPET.quant.parent = B.parent;
else
    fPET.quant.parent.d_int = 1;
    fPET.quant.parent.d_int_compl = 1;
end

% calculate remaining blood data
if ~isnan(sum(fPET.quant.wb.d_int)) && ~isnan(sum(fPET.quant.pwbr.d_fit)) && isnan(sum(fPET.quant.p.d_int))
    fPET.quant.p.d_int = fPET.quant.wb.d_int.*fPET.quant.pwbr.d_fit.*fPET.quant.parent.d_int;
    % complete blood data for incomplete data (advanced)
    if fPET.Y.incomplete == 1
        fPET.quant.p.d_int_compl = fPET.quant.wb.d_int_compl.*fPET.quant.pwbr.d_fit_compl.*fPET.quant.parent.d_int_compl;
    end
elseif ~isnan(sum(fPET.quant.p.d_int)) && ~isnan(sum(fPET.quant.pwbr.d_fit)) && isnan(sum(fPET.quant.wb.d_int))
    fPET.quant.wb.d_int = fPET.quant.p.d_int./fPET.quant.pwbr.d_fit./fPET.quant.parent.d_int;
    % complete blood data for incomplete data (advanced)
    if fPET.Y.incomplete == 1
        fPET.quant.wb.d_int_compl = fPET.quant.p.d_int_compl./fPET.quant.pwbr.d_fit_compl./fPET.quant.parent.d_int_compl;
    end
elseif ~isnan(sum(fPET.quant.p.d_int)) && isnan(sum(fPET.quant.pwbr.d_fit)) && isnan(sum(fPET.quant.wb.d_int))
    fPET.quant.wb.d_int = fPET.quant.p.d_int;
    fPET.quant.vb = 0;
    % complete blood data for incomplete data (advanced)
    if fPET.Y.incomplete == 1
        fPET.quant.wb.d_int_compl = fPET.quant.p.d_int_compl;
    end
end

% prescan blood glucose level [mmol/L]
if isfield(fpetbatch.quant.in,'bloodlvl') && ~isempty(fpetbatch.quant.in.bloodlvl)
    fPET.quant.bloodlvl = fpetbatch.quant.in.bloodlvl;
else
    fPET.quant.bloodlvl = NaN;
end

% lumped constant
if isfield(fpetbatch.quant.in,'lc') && ~isempty(fpetbatch.quant.in.lc)
    fPET.quant.lc = fpetbatch.quant.in.lc;
else
    fPET.quant.lc = fpet_defaults.quant.in.lc;
end

% t* for Patlak plot
if isfield(fpetbatch.quant.in,'tstar') && ~isempty(fpetbatch.quant.in.tstar)
    fPET.quant.tstar = fpetbatch.quant.in.tstar;
else
    fPET.quant.tstar = fpet_defaults.quant.in.tstar;
end

% save defaults
save(fullfile(fPET.dir.result, 'fPET_glm.mat'), 'fPET');
pn = fPET.dir.result;

end
