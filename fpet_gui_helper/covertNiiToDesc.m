function tmp = covertNiiToDesc(input)
% fPET toolbox: helper function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
if size(input, 1) > 1
    tmp = sprintf('%dx%d Data array', size(input));
else
    if iscell(input)
        tmp = cell2mat(input);
    else
        tmp = input;
    end
end
end