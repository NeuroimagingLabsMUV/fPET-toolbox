function value = convertBLToVal(name)
% fPET toolbox: helper function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
    if strcmp(name, 'Mask')
        value = 1;
    elseif strcmp(name, '3rd Order Polynomial')
        value = 2;
    else
        value = str2double(name); 
    end
end