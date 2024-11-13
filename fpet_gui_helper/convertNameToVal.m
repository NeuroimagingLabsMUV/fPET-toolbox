function value = convertNameToVal(name)
% fPET toolbox: helper function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
    if strcmp(name, 'Seconds')
        value = 1;
    elseif strcmp(name, 'Frames')
        value = 2;
    else
        value = str2double(name); 
    end
end
