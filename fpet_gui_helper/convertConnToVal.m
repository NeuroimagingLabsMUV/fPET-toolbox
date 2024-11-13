function value = convertConnToVal(name)
% fPET toolbox: helper function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
    if strcmp(name, 'Mask')
        value = 1;
    elseif strcmp(name, '3rd Order Polynomial Detrending (Global)')
        value = 2;
    elseif strcmp(name, '3rd Order Polynomial Detrending (per ROI)')
        value = 3;
%     elseif strcmp(name, 'Spatio-temporal Filter')
%         value = 4;
%     elseif strcmp(name, 'Bandpass Filter')
%         value = 5;
    else
        value = str2double(name); 
    end
end

