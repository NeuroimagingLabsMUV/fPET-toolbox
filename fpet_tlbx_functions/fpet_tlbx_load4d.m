function Y = fpet_tlbx_load4d(pnfn, rem_start, rem_end);
% fpet toolbox: load 4D fPET data
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria

Y.h = spm_vol(pnfn);
Y.h_orig = Y.h;
Y.dir = pnfn;

% remove initial or final frames (advanced)
if ~isempty(rem_start)
    Y.h(1:rem_start) = [];
end
if ~isempty(rem_end)
    Y.h(end-rem_end+1:end) = [];
end

Y.d = spm_read_vols(Y.h);
Y.d(isinf(Y.d)) = NaN;



end