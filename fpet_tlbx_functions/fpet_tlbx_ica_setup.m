function pn = fpet_tlbx_ica_setup(fpetbatch);
% fPET toolbox: set default values for ica
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
if isfield(fpetbatch.ica.in,'rem_start') && ~isempty(fpetbatch.ica.in.rem_start)
    if fpetbatch.ica.in.time == 1
        fPET.ica.X.rem.start = round(fpetbatch.ica.in.rem_start/fpetbatch.ica.in.framelength);
    elseif fpetbatch.ica.in.time == 2
        fPET.ica.X.rem.start = fpetbatch.ica.in.rem_start;
    end
else
    fPET.ica.X.rem.start = fpet_defaults.ica.in.rem_start;
end
if isfield(fpetbatch.ica.in,'rem_end') && ~isempty(fpetbatch.ica.in.rem_end)
    if fpetbatch.ica.in.time == 1
        fPET.ica.X.rem.end = round(fpetbatch.ica.in.rem_end/fpetbatch.ica.in.framelength);
    elseif fpetbatch.ica.in.time == 2
        fPET.ica.X.rem.end = fpetbatch.ica.in.rem_end;
    end
else
    fPET.ica.X.rem.end = fpet_defaults.ica.in.rem_end;
end

% data
fPET.ica.files = fpetbatch.ica.in.data;

% framelength
if isfield(fpetbatch.ica.in,'framelength') && ~isempty(fpetbatch.ica.in.framelength)
    fPET.framelength = fpetbatch.ica.in.framelength;
end

% mask where calculations are done
M.calc.h = spm_vol(fpetbatch.ica.in.mask.calc);
M.calc.d = spm_read_vols(M.calc.h);
M.calc.d(isinf(M.calc.d)) = 0;
M.calc.d(isnan(M.calc.d)) = 0;
M.calc.d(M.calc.d~=0) = 1;
M.calc.d = logical(M.calc.d);
fPET.ica.M.calc = M.calc;

% principal components
if isfield(fpetbatch.ica.in,'pc') && ~isempty(fpetbatch.ica.in.pc)
    fPET.ica.pc = fpetbatch.ica.in.pc;
else
    fPET.ica.pc = fpet_defaults.ica.in.pc;
end

% independent components
if isfield(fpetbatch.ica.in,'ic') && ~isempty(fpetbatch.ica.in.ic)
    fPET.ica.ic = fpetbatch.ica.in.ic;
else
    fPET.ica.ic = fpet_defaults.ica.ic;
end

% dimensionality reduction
if isfield(fpetbatch.ica.in,'pca') && ~isempty(fpetbatch.ica.in.pca)
    fPET.ica.pca = fpetbatch.ica.in.pca;
else
    fPET.ica.pca = fpet_defaults.ica.in.pca;
end

% save values
save(fullfile(fPET.dir.result, 'fPET_ica.mat'), 'fPET');
pn = fPET.dir.result;

end


