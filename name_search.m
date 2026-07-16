
function [position,colon] = name_search(comments, name)
    
    %This will take in the comment array and a component name and return
    %position of first instance (only instance assuming uniqueness)
    
    [length, ~] = size(comments);
    position = -1; colon = -1;
    if(all(size(name)))
        switch(contains(name, ':'))
            case 1
                colon = name(strfind(name,':')+1:end);
                for k = 1:length
                    if(contains(comments(k), name(1:strfind(name,':')-1), 'IgnoreCase', true))
                        position = k;
                        break;
                    end
                end    
            case 0
                for k = 1:length
                    if(contains(comments(k), name, 'IgnoreCase', true))
                        position = k;
                        break;
                    end
                end
        end
    end 
%full function end
end

%Overload to get array of values for repeats?
%function [position] = name_search(comments, name, 'rep')

