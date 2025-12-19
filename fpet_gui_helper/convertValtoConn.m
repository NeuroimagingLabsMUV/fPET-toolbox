function result = convertValtoConn(value)
% fPET toolbox: helper function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
if value == 1
    result = 'Mask';
elseif value == 2
    result = '3rd Order Polynomial Detrending (Global)';
elseif value == 3
    result = '3rd Order Polynomial Detrending (per ROI)';
 elseif value == 4
     result = 'Spatio-temporal Filter';
 elseif value == 5
     result = 'CompCor Filter';
elseif value == 6
    result = 'Baseline normalization';
elseif value == 7
    result = 'Euclidean distance';
else
    result = num2str(value); 
end
end