%Wien Filters

function out = VW(L, phi)
    drift = [1,L;0,1];
    out = [drift,zeros(2);zeros(2),drift];
    if(abs(phi) > 1e-8)
        R = L/phi;
        wien_part = [cos(phi), R*sin(phi);-1/R*sin(phi), cos(phi)];
        out = [wien_part, zeros(2); zeros(2), drift];
    end
end