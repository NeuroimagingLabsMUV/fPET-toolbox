function pn = fpet_tlbx_psc_setup(fpetbatch);
% fPET toolbox: set default values for percent signal change
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria

% result directory
if isfield(fpetbatch,'dir') && isfield(fpetbatch.dir,'result') && ~isempty(fpetbatch.dir.result)
    pn = fpetbatch.dir.result;
else
    pn = pwd;
end
cd(pn);

end
