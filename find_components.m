%find_components.m, Jude D.

function [compPos] = find_components(name, comments)
    compPos = [];
    for k=1:length(comments)
        if contains(comments(k),name)
            compPos = [compPos;k];    
        end
    end
end