%QQ.m - Thick Quadrupoles

function out = QQ(L, k1)

    out = eye(4);
    ksq=sqrt(abs(k1));
    out1=[cos(ksq*L),sin(ksq*L)/ksq;-ksq*sin(ksq*L),cos(ksq*L)];
    out2=[cosh(ksq*L),sinh(ksq*L)/ksq;ksq*sinh(ksq*L),cosh(ksq*L)];
    
    if abs(k1) < 1e-6 %If off, return drift
        out(1,2) = L;
        out(3,4) = L;
    elseif k>0
        out=[out1, zeros(2); zeros(2), out2];
    else
        out=[out2, zeros(2); zeros(2), out1];        
    end

end
