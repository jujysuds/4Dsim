function [xVals,yVals] = orbit_calc(r0, Racc, Rtotal, nmat, xdisp, ydisp)
    
    xVals = zeros(nmat,1);
    %xpVals = zeros(nmat,1);
    yVals = zeros(nmat,1);
    %ypVals = zeros(nmat,1);
    
    for k = 1:nmat
    
        %~~~find x/y Displacements Here~~~%
        result = zeros(4,1);
    
        for j = 1:k-1
            m_j = [xdisp(j),0,ydisp(j),0]'; 
            q_j = (Rtotal(:,:,j) - eye(4)) * m_j;
            if(~isequal(q_j,zeros(4,1)))
                out = matmult(Rtotal, j+1, k);
                result = result + (out * q_j);
            end
        end
    
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
    
        r = Racc(:,:,k) * r0; 
        r = r + result; %this is the new line associated with displacements
    
        xVals(k) = r(1); %xpVals(k) = r(2);
        yVals(k) = r(3); %ypVals(k) = r(4);
    
    end
end