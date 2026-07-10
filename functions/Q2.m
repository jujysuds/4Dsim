%Thin quadrupole lens - Q2 for 2 dimensional action

function out = Q2(F)

    out = eye(4); out(2,1) = -1/F; out(4,3) = 1/F;

end