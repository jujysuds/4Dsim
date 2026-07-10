function just_plot(spos, xVals, yVals, betaX, betaY, bpmVec, bpmnames)

    subplot(2,2,1)
    x = plot(spos, xVals, 'r.-');
    title('x[mm] vs s[m]');
    xlabel('s[m]');
    ylabel('x[mm]');
    ylim([-5, 5]);

    x.XDataSource = "spos";
    x.YDataSource = "xVals";

    subplot(2,2,2)
    y = plot(spos, yVals, 'b.-');
    title('y[mm] vs s[m]');
    xlabel('s[m]');
    ylabel('y[mm]');
    ylim([-5, 5]);

    y.XDataSource = "spos";
    y.YDataSource = "yVals";

    subplot(2,2,3)
    beta = plot(spos, betaX(:), spos,betaY(:), '--');
    title('\beta(s) vs s');
    xlabel('s[m]');
    ylabel('\beta(s)');
    legend('\beta_x(s)','\beta_y(s)');
    ylim([-3, 20]);
    
    beta(1).XDataSource = "spos";
    beta(2).YDataSource = "betaX(:)";
    beta(2).XDataSource = "spos";
    beta(2).YDataSource = "betaY(:)";

    
    subplot(2,2,4);
    barpm = bar(bpmnames,bpmVec);
    xlabel('BPM');
    ylabel('x[mm], y[mm]');
    legend('x', 'y')
    ylim([-10,10])

    barpm(1).XDataSource = "bpmnames";
    barpm(1).YDataSource = "bpmVec(:,1)";
    barpm(2).XDataSource = "bpmnames";
    barpm(2).YDataSource = "bpmVec(:,2)";


end

