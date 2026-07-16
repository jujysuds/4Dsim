%Horizontal Wien Filters

function out = HW(L, phi)
    length = [1,L;0,1];
    out = [length,zeros(2);zeros(2),length];
    if(abs(phi) > 1e-8)
        R = L/phi;
        wien_part = [cos(phi), R*sin(phi);-1/R*sin(phi), cos(phi)];
        out = [length, zeros(2); zeros(2), wien_part];
    end
end