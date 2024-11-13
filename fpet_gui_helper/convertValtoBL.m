function result = convertValtoBL(value)
% fPET toolbox: helper function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
if value == 1
    result = 'Mask';
elseif value == 2
    result = '3rd Order Polynomial';
else
    result = num2str(value); 
end
end