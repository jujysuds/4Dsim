%Solenoid

function out=SOL(L,KS)
    if abs(KS) < 1e-6, out=eye(4); return; end
    phis=KS*L/2;
    c=cos(phis);
    s=sin(phis);
    QS=[c, 2*s/KS; -KS*s/2, c];
    R=zeros(4);
    R(1,1)=c; R(1,3)=s; R(2,2)=c; R(2,4)=s;
    R(3,1)=-s; R(3,3)=c; R(4,2)=-s; R(4,4)=c;
    out=R*[QS,zeros(2);zeros(2),QS];
end
