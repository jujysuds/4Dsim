function out = matmult(multimat, start, finish)
    %dimr = length(multimat(1,:,1));
    %dimc = length(multimat(:,1,1));
    %out = zeros(dimr,dimc);
    out = eye(4);
    
    for k=start:finish
        out = multimat(:,:,k) * out;
    end

end