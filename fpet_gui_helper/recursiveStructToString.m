function codeStr = recursiveStructToString(s, parentName, indentLevel)
% fPET toolbox: helper function 
% 
% Copyright (C) 2024, Neuroimaging Labs, Medical University of Vienna, Austria
    % Initialize the string
    codeStr = '';
    indent = repmat('    ', 1, indentLevel); % 4 spaces per indent level

    % Get all the field names of the structure
    fields = fieldnames(s);
    
    for i = 1:length(fields)
        fieldName = fields{i};
        fieldValue = s.(fieldName);
        fullName = [parentName, '.', fieldName];

        % Check if the field is a structure
        if isstruct(fieldValue)
            % Check if the structure is an array
            if numel(fieldValue) > 1
                % Handle array of structures
                for j = 1:numel(fieldValue)
                    arrayFullName = sprintf('%s(%d)', fullName, j);
                    codeStr = [codeStr, recursiveStructToString(fieldValue(j), arrayFullName, indentLevel + 1)];
                end
            else
                % Recurse into the single structure field
                codeStr = [codeStr, recursiveStructToString(fieldValue, fullName, indentLevel + 1)];
            end
        else
            % Convert the field value to string based on its type
            if isnumeric(fieldValue) || islogical(fieldValue)
                valueStr = mat2str(fieldValue);
            elseif ischar(fieldValue)
                valueStr = ['''', fieldValue, ''''];
            elseif iscell(fieldValue)
                valueStr = '{';
                for j = 1:numel(fieldValue)
                    if ischar(fieldValue{j})
                        % Handle cell array of strings
                        elementStr = ['''', fieldValue{j}, ''''];
                    elseif isnumeric(fieldValue{j}) || islogical(fieldValue{j})
                        % Handle cell array of numbers or logicals
                        elementStr = mat2str(fieldValue{j});
                    elseif iscell(fieldValue{j})
                        % Recursively handle nested cell arrays
                        elementStr = recursiveStructToString(fieldValue{j}, '', indentLevel + 1);
                    elseif isstruct(fieldValue{j})
                        % Recursively handle structure inside a cell
                        elementStr = recursiveStructToString(fieldValue{j}, '', indentLevel + 1);
                    else
                        elementStr = 'UnsupportedType';
                    end
                    
                    valueStr = [valueStr, elementStr];
                    if j < numel(fieldValue)
                        valueStr = [valueStr, ', '];
                    end
                end
                valueStr = [valueStr, '}'];
            else
                valueStr = 'UnsupportedType';
            end
            
            % Append the field and its value to the code string
            codeStr = [codeStr, indent, fullName, ' = ', valueStr, ';', newline];
        end
    end
end
