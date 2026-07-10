function [betaX, betaY] = sigma_calc(sigma0, Racc, nmat)
    
    betaX = zeros(nmat,1);
    betaY = zeros(nmat,1);

    for k=1:nmat
        sigma = Racc(:,:,k)*sigma0*Racc(:,:,k)';
        betaX(k) = sigma(1,1);
        betaY(k) = sigma(3,3);
    end


end