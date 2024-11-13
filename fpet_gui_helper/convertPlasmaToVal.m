function value = convertPlasmaToVal(name)
% fPET toolbox: helper function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
    if strcmp(name, 'Average')
        value = 1;
    elseif strcmp(name, 'Linear Fit')
        value = 2;
    else
        value = str2double(name); 
    end
end
