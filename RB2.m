%Rectangular Bend Dipole

function out=RB2(L, rho)
    phi = L/rho;
    out = eye(4);
    out(1,2) = L;
    if abs(phi)<1e-8
        out(3,4) = L;
    else
    
        out(3:4,3:4) = [cos(phi),rho*sin(phi);...
            -sin(phi)/rho,cos(phi)];

    end
end
