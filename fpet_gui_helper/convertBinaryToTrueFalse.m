function result = convertBinaryToTrueFalse(value)
% fPET toolbox: helper function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
if value == 1
    result = 'true';
elseif value == 0
    result = 'false';
else
    result = num2str(value); % Handle other values if necessary
end
end