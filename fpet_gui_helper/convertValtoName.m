function result = convertValtoName(value)
% fPET toolbox: helper function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
if value == 1
    result = 'Seconds';
elseif value == 2
    result = 'Frames';
else
    result = ''; 
end
end

