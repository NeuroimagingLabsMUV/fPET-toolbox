function value = convertPadToVal(name)
% fPET toolbox: helper function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
    if strcmp(name, 'Beginning')
        value = 1;
    elseif strcmp(name, 'End')
        value = 2;
    elseif strcmp(name, 'None')
        value = 0;
    else
        value = 0; 
    end
end
