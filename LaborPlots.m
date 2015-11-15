fs = 12; lw = 2; i=1; k=1; rows = 2; cols = 3;
figure('Position', [100,100,800,600])
T=2*length(Closed.thetaH);
subplot(rows,cols,i), plot((Open.thetaH(1:T/2-50)-SS.thetaH)/SS.thetaH,'--r', 'LineWidth', lw)
    hold on
    plot((Closed.thetaH(1:T/2-50)-SS.thetaH)/SS.thetaH,'-b', 'LineWidth', lw)
	set(gca, 'FontSize', fs)
    title('High Skill Market Tightness')
    legend('Open Economy','Closed Economy')
    xlabel('Time')
    ylabel('Percentage Deviation')
    i=i+1;
 
subplot(rows,cols,i), plot((Open.UHN(1:T/2-50)-SS.UHN)/SS.UHN,'--r', 'LineWidth', lw)
    hold on
    plot((Closed.UHN(1:T/2-50)-SS.UHN)/SS.UHN,'-b', 'LineWidth', lw)
	set(gca, 'FontSize', fs)
    title('High Skill Native Unemployment')
    legend('Open Economy','Closed Economy')
    xlabel('Time')
    ylabel('Percentage Deviation')
    i=i+1;
    
subplot(rows,cols,i), plot((Open.wHN(1:T/2-50)-SS.wHN)/SS.wHN,'--r', 'LineWidth', lw)
    hold on
    plot((Closed.wHN(1:T/2-50)-SS.wHN)/SS.wHN,'-b', 'LineWidth', lw)
	set(gca, 'FontSize', fs)
    title('High Skill Native Wage')
    legend('Open Economy','Closed Economy')
    xlabel('Time')
    ylabel('Percentage Deviation')
    i=i+1;
    
subplot(rows,cols,i), plot((Open.thetaL(1:T/2-50)-SS.thetaL)/SS.thetaL,'--r', 'LineWidth', lw)
    hold on
    plot((Closed.thetaL(1:T/2-50)-SS.thetaL)/SS.thetaL,'-b', 'LineWidth', lw)
	set(gca, 'FontSize', fs)
    title('Low Skill Market Tightness')
    legend('Open Economy','Closed Economy')
    xlabel('Time')
    ylabel('Percentage Deviation')
    i=i+1;
    
subplot(rows,cols,i), plot((Open.ULN(1:T/2-50)-SS.ULN)/SS.ULN,'--r', 'LineWidth', lw)
    hold on
    plot((Closed.ULN(1:T/2-50)-SS.ULN)/SS.ULN,'-b', 'LineWidth', lw)
	set(gca, 'FontSize', fs)
    title('Low Skill Native Unemployment')
    legend('Open Economy','Closed Economy')
    xlabel('Time')
    ylabel('Percentage Deviation')
    i=i+1;
    
subplot(rows,cols,i), plot((Open.wLN(1:T/2-50)-SS.wLN)/SS.wLN,'--r', 'LineWidth', lw)
    hold on
    plot((Closed.wLN(1:T/2-50)-SS.wLN)/SS.wLN,'-b', 'LineWidth', lw)
	set(gca, 'FontSize', fs)
    title('Low Skill Native Wage')
    legend('Open Economy','Closed Economy')
    xlabel('Time')
    ylabel('Percentage Deviation')
    i=i+1;