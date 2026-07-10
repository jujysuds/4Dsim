%Sector Bend Dipole

function out=SB(L,rho)
    phi=L/rho;
    out=eye(4);
    if abs(phi)<1e-8
        out(1,2) = L;
        out(3,4) = L;
    else
        out(1,1:2)=[cos(phi),rho*sin(phi)];
        out(2,1:2)=[-sin(phi)/rho,cos(phi)];
        out(3,4)=L;
    end
end
