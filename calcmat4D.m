%4D (i.e. x- and y-capacities) Analogue to calcmat.m, Jude D.

function [Racc, spos, nmat, nlines, Rtotal, state] = calcmat4D(beamline,extraparams,r0)

    nlines = size(beamline, 1); nmat = sum(beamline(:,2)) + 1;
    Racc = zeros(4, 4, nmat); Racc(:,:, 1) = eye(4);
    spos = zeros(nmat, 1);
    Rtotal = zeros(4, 4, nmat);Rtotal(:,:,1) = eye(4);
    state = zeros(4,nmat); state(:,1) = r0;

    ic = 1;
    for line=1:nlines
        for seg=1:beamline(line,2)
            ic = ic + 1;
            Rcurr = eye(4);
            q = zeros(4,1);
            switch beamline(line,1)
                case 0
                    %Rcurr = M(0); commented out because acts as identity
                case 1
                    Rcurr = D2(beamline(line,3));
                case 2
                    Rcurr = Q2(beamline(line,4));
                case 4
                    beamphi = beamline(line,4)*pi/180;
                    rho = beamline(line,3)/beamphi;
                    Rcurr = SB(beamline(line,3),rho);
                case 5
                    Rcurr = QQ(beamline(line,3),beamline(line,4));
                    tempvector = extraparams{line};
                    m = [tempvector(1);0;tempvector(2);0];
                    q = (Rcurr - eye(4)) * m; 
                case 7
                    %Rcurr = C(0); no functionality yet
                    tempvector = extraparams{line};
                    q = [0;tempvector(1);0;tempvector(2)];
                case 19
                    Rcurr = SOL(beamline(line,3),beamline(line,4));
                case 44
                    Rcurr = RB(beamline(line,3),beamline(line,4));
                case 103 
                    %Rcurr = B(beamline(line,4)); %IPMs
                    %May have act as drift to add noise
                
                %case 300 | have to add support for measured transfer mats?
                
                %{
                case 20 {Wien Filters, matrices in tech note by Volker Z.}
                    Rcurr = WF(beamline(line,3),beamline(line,4));
                
                
                %}
                otherwise 
                    disp('unsupported code')
            end
            Rtotal(:,:,ic) = Rcurr;
            Racc(:,:,ic) = Rcurr * Racc(:,:,ic-1);
            state(:,ic) = Rcurr * state(:,ic-1);
            state(:,ic) = state(:,ic) + q;
            spos(ic) = spos(ic-1) + beamline(line,3);
        end
    end

%full function end
end