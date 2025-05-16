function fpetbatch = fpet_tlbx_tacplot_setup(fpetbatch);
% fPET toolbox: set defaults to plot task-specific activation
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria

% load defaults
fpet_defaults = fpet_tlbx_defaults();

% glm
if ~isfield(fpetbatch.tacplot.in,'type') || isempty(fpetbatch.tacplot.in.type) || (fpetbatch.tacplot.in.type == 1)
    fpetbatch.tacplot.in.type = 1;
    if ~isfield(fpetbatch.tacplot.in,'indiv') || isempty(fpetbatch.tacplot.in.indiv)
        fpetbatch.tacplot.in.indiv = fpet_defaults.tacplot.in.indiv;
    end
    if ~isfield(fpetbatch.tacplot.in,'average') || isempty(fpetbatch.tacplot.in.average)
        fpetbatch.tacplot.in.average = fpet_defaults.tacplot.in.average;
    end
    if ~isfield(fpetbatch.tacplot.in,'raw') || isempty(fpetbatch.tacplot.in.raw)
        fpetbatch.tacplot.in.raw = fpet_defaults.tacplot.in.raw;
    end

% ica
elseif fpetbatch.tacplot.in.type == 2
    if ~isfield(fpetbatch.tacplot.in,'framelength') || isempty(fpetbatch.tacplot.in.framelength)
        pnfn = fullfile(fpetbatch.tacplot.in.dir{1,1}, 'fPET_ica.mat');
        load(pnfn);
        fpetbatch.tacplot.in.framelength = fPET.framelength;
    end
end


end

