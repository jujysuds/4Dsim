%Rectangular Bend Dipole

function out=RB1(L, rho)
    phi = L/rho;
    out = eye(4);
    if abs(phi)<1e-8
        out(1,2) = L;
        out(3,4) = L;
    else
        R_f = [1,0,0,0;tan(phi/2)/rho,1,0,0;
            0,0,1,0; 0,0,-tan(phi/2)/rho,1];
    
        R_s = [cos(phi),rho*sin(phi),0,0;
            -sin(phi)/rho,cos(phi),0,0;
            0,0,1,L; 0,0,0,1];
    
        out = R_f*R_s*R_f;
    
    end
end
