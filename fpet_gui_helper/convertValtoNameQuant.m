function result = convertValtoNameQuant(value)
% fPET toolbox: helper function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
if value == 1
    result = 'Blood';
elseif value == 2
    result = 'Reference region';
elseif value == 3
    result = 'Both';
else
    result = ''; 
end
end

