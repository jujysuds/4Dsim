function [bpmVec,bpmnames] = bpm_calc(xVals,yVals,comments)
    
    bpmVec = [];
    bpmnames = [];
    
    bpms = find_components("IPM", comments);
    if(isempty(bpms)) return; end
    
    xVec = zeros(length(bpms),1);
    yVec = zeros(length(bpms),1);
    bpmVec = zeros(length(bpms),2);
    bpmnames = strings(length(bpms),1);

    for k = 1:length(bpms)
        xVec(k) = xVals(bpms(k)); 
        yVec(k) = yVals(bpms(k));
        bpmVec(k,:) =  [xVals(bpms(k)), yVals(bpms(k))];
        bpmnames(k) = comments(bpms(k));
    end
end