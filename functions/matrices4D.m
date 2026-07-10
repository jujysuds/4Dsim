%Transfer Matrices for all the components for viewing pleasure
%------------------------------------------
    %Drift Space - D2 for 2 dimensions of drift
    D2 =  @(L)[1, L, 0, 0; 
               0, 1, 0, 0;
               0, 0, 1, L;
               0, 0, 0, 1];
        
    %Thin quadrupole lens - Q2 for 2 dimensional action
    Q2 = @(F)[1, 0, 0, 0;
           -1/F, 1, 0, 0; 
              0, 0, 1, 0;
              0, 0,1/F,1];

    %Thick Quad QQ
   
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

    %Solenoid
    
    %Investigate differences between S (Wolski) and SOL (Ziemann)
    
    function out=S(L,ks)
        out=eye(4);   
        if abs(ks)>1e-8
            out(1,1:4)=[(cos(ks*L))^2,1/(2*ks)*sin(2*ks*L),1/2*sin(2*ks*L),1/ks*(sin(ks*L))^2];
            out(2,1:4)=[-ks/2*sin(2*ks*L),(cos(ks*L))^2,-ks*(sin(ks*L))^2,1/2*sin(2*ks*L)];
            out(3,1:4)=[-1/2*sin(2*ks*L),-1/ks*(sin(ks*L))^2,(cos(ks*L))^2,1/(2*ks)*sin(2*ks*L)];
            out(4,1:4)=[ks*(sin(ks*L))^2,-1/2*sin(2*ks*L),-ks/2*sin(2*ks*L),(cos(ks*L))^2];
        end
        out(1,2) = L;
        out(3,4) = L;
    end
    
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


    %Rectangular Bend Dipole
    
    function out=RB(L, rho)
        phi = L/rho;
        out = eye(4);
        if abs(phi)<1e-8
            out(1,2) = L;
            out(3,4) = L;
        else
            R_f = [1,0,0,0;tan(phi/2)/2*rho,1,0,0;
                   0,0,1,0; 0,0,-tan(phi/2)/2*rho,1];
            
            R_s = [cos(phi),rho*sin(phi),0,0;
                   -sin(phi)/rho,cos(phi),0,0;
                   0,0,1,L; 0,0,0,1];
            
            out = R_f*R_s*R_f;
    
        end
    end

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

    %!!Corrector Needs to be Changed!!
    %Corrector - perhaps 2 more columns on beamline for corrector kicks?
    C = @(X)[1, 0, 0, 0;
             0, 1, 0, 0; 
             0, 0, 1, 0;
             0, 0, 0, 1];
    
    %Non-Adjusting Elements - may wish to make these have real inputs in future

    %BPM- perhaps becomes drift space with its strength giving dist. effect
    B = @(X)[1, X, 0, 0;
             0, 1, 0, 0; 
             0, 0, 1, X;
             0, 0, 0, 1];

    %Marker
    M = @(X)[1, 0, 0, 0;
             0, 1, 0, 0; 
             0, 0, 1, 0;
             0, 0, 0, 1];

%-----------------------------------------
%End of Matrices
