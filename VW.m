%Wien Filters

function out = VW(L, R)
    out = eye(4);
    length = [1,L;0,1];
    if(abs(R) > 1e-8)
        phi = L/R;
        wien_part = [cos(phi), R*sin(phi);-1/R*sin(phi), cos(phi)];
        out = [wien_part, zeros(2); zeros(2), length];
    else
        out = [length,zeros(2);zeros(2),length];
    end
end