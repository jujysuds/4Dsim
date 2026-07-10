%This function identifies the first instance of a non-numerical token in a string (component names are the expected return string)

function [compPos] = find_comp(splitstring)
    for j = 1:length(splitstring)
        if(isempty(str2num(splitstring{j})))
            compPos = j;
            break;
        end
    end
end
