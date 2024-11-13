function result = convertValtoPlasma(value)
% fPET toolbox: helper function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
if value == 1
    result = 'Average';
elseif value == 2
    result = 'Linear Fit';
else
    result = num2str(value); 
end
end