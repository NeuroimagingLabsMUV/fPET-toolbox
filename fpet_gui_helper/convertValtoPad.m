function result = convertValtoPad(value)
% fPET toolbox: helper function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
if value == 1
    result = 'Beginning';
elseif value == 2
    result = 'End';
elseif value == 0
    result = 'None';
else
    result = num2str(value); 
end
end
