function [] = plot_everything(beamline,sigma0, r0, comments)

%{
%           Run as Program = Uncomment
%----------------------------------------------------
clear;
[beamline, comments] = matlab_input('input.txt');

%[Racc, spos, nmat, nlines] = calcmat4D(beamline);
%[Q, alpha, beta, gamma] = R2Beta(Racc(:,:,end));

%Measured initial values
betax=0.769; alphax=-0.692; gammax=(1+alphax^2)/betax;
betay=0.559; alphay=0.221; gammay=(1+alphay^2)/betay;

sigmax=[betax,-alphax;-alphax,gammax];
sigmay=[betay,-alphay;-alphay,gammay];
sigma0=[sigmax, zeros(2);zeros(2),sigmay];

r0 = [1;0;1;0];
%----------------------------------------------------
%}
    
    %Currently 4D matrices, handled by calcmat4D
    [Racc, spos, nmat, ~, Rtotal] = calcmat4D(beamline);
    betaX = zeros(nmat,1);
    betaY = zeros(nmat,1);
    
    xVals = zeros(nmat,1);
    xpVals = zeros(nmat,1);
    yVals = zeros(nmat,1);
    ypVals = zeros(nmat,1);
       
    dispmu = 0.2; %units of xy length already in mm, no need to x10^-3?

    for k=1:nmat
        sigma = Racc(:,:,k)*sigma0*Racc(:,:,k)';
        betaX(k) = sigma(1,1);
        betaY(k) = sigma(3,3);
    end
    
    xdisp = dispmu * randn(nmat,1); ydisp = dispmu * randn(nmat,1);

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
        
        xVals(k) = r(1); xpVals(k) = r(2);
        yVals(k) = r(3); ypVals(k) = r(4);
    
    end
    
    subplot(2,2,1)
    plot(spos, xVals, 'r.-');
    title('x[mm] vs s[m]');
    xlabel('s[m]');
    ylabel('x[mm]');
    ylim([-5, 5]);

    subplot(2,2,2)
    plot(spos, yVals, 'b.-');
    title('y[mm] vs s[m]');
    xlabel('s[m]');
    ylabel('y[mm]');
    ylim([-5, 5]);

    subplot(2,2,3)
    plot(spos, betaX(:), spos,betaY(:), '--');
    title('\beta(s) vs s');
    xlabel('s[m]');
    ylabel('\beta(s)');
    legend('\beta_x(s)','\beta_y(s)');
    ylim([-3, 20]);

%Commented out to test imperfections

    %Measuring Distance from Optical Axis at BPM Locations
    xVec = [];
    yVec = [];
    totalVec = [];
    bpmnames = [];

    bpms = find_components("IPM", comments);
    
    %Can preallocate all of these vectors to length(bpms)
    for k = 1:length(bpms)
        xVec = [xVec; xVals(bpms(k))]; 
        yVec = [yVec; yVals(bpms(k))];
        totalVec = [totalVec; xVals(bpms(k)), yVals(bpms(k))];
        bpmnames = [bpmnames; comments(bpms(k))];
    end
    
    subplot(2,2,4);
    bar(bpmnames,totalVec);
    xlabel('BPM');
    ylabel('x[mm], y[mm]');
    legend('x', 'y')
    ylim([-10,10])

%}

    drawnow;

%full function end
end

function out = matmult(multimat, int1, int2)
    %dimr = length(multimat(1,:,1));
    %dimc = length(multimat(:,1,1));
    %out = zeros(dimr,dimc);
    out = eye(4);

    for k=int1:int2
        out = multimat(:,:,k) * out;
    end

end