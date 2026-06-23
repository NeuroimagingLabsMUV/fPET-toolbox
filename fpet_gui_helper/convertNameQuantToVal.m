function value = convertNameQuantToVal(name)
% fPET toolbox: helper function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
    if strcmp(name, 'Blood')
        value = 1;
    elseif strcmp(name, 'Reference region')
        value = 2;
    elseif strcmp(name, 'Both')
        value = 3;
    else
        value = str2double(name); 
    end
end
