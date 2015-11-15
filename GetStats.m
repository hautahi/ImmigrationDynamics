% Zero profit condition, solving for thetas

function Stats = GetStats(Tr,Experiment)
global SS beta bLN bHN SS2

%%%%%%%%%%%%%%% Utility Measures %%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate
UtilityHN = GetUtil(Tr.CHN,Tr.EHN,bHN); UtilityLN = GetUtil(Tr.CLN,Tr.ELN,bLN);

% On Impact
lamHN = (exp((UtilityHN.sum + UtilityHN.BETA(end)*beta*UtilityHN.t(end)/(1-beta))*(1-beta))+bHN*SS.EHN)/SS.cHN-1;
lamLN = (exp((UtilityLN.sum + UtilityLN.BETA(end)*beta*UtilityLN.t(end)/(1-beta))*(1-beta))+bLN*SS.ELN)/SS.cLN-1;

% Long Run
lamHNstar = (exp(UtilityHN.t(end))+bHN*SS.EHN)/SS.cHN-1;
lamLNstar = (exp(UtilityLN.t(end))+bLN*SS.ELN)/SS.cLN-1;

%%%%%%%%%%%%%%% Labor Market %%%%%%%%%%%%%%%%%%%%%%%%%%
% SS Percentage Change
wHN = (SS2.wHN - SS.wHN)/SS.wHN; wLN = (SS2.wLN - SS.wLN)/SS.wLN;
uHN = (SS2.UHN - SS.UHN)/SS.UHN; uLN = (SS2.ULN - SS.ULN)/SS.ULN;

% PV Calcs
BETA = cumprod([1 beta*ones(1, length(Tr.q(1:end-1)))]);
PVwHN = (sum(BETA.*Tr.EHN.*Tr.wHN) + BETA(end)*beta/(1-beta)*Tr.EHN(end)*Tr.wHN(end))/(SS.EHN*SS.wHN/(1-beta))-1;
PVwLN = (sum(BETA.*Tr.ELN.*Tr.wLN) + BETA(end)*beta/(1-beta)*Tr.ELN(end)*Tr.wLN(end))/(SS.ELN*SS.wLN/(1-beta))-1;

pH = (SS2.pH - SS.pH)/SS.pH; pL = SS2.pL - SS.pL; 

%%%%%%%%%%%%%%% Asset and Consumption %%%%%%%%%%%%%%%%%%%%%%%%%%
% SS Percentage Change
aHN = (Tr.aHN(end) - SS.aHN)/SS.aHN; aLN = (Tr.aLN(end) - SS.aLN)/SS.aLN;
CHN = (Tr.CHN(end) - SS.cHN)/SS.cHN; CLN = (Tr.CLN(end) - SS.cLN)/SS.cLN;
aHNimpact = (Tr.aHN(1) - SS.aHN)/SS.aHN; aLNimpact = (Tr.aLN(1) - SS.aLN)/SS.aLN;

% PV Calcs
% PVaHN = (sum(BETA(1:end-1).*(Tr.aHN(1:end-1)-Tr.q(1:end-1).*Tr.aHN(2:end))) + BETA(end)/(1-beta)*Tr.aHN(end)*(1-beta))/(SS.aHN)-1;
% PVaLN = (sum(BETA(1:end-1).*(Tr.aLN(1:end-1)-Tr.q(1:end-1).*Tr.aLN(2:end))) + BETA(end)/(1-beta)*Tr.aLN(end)*(1-beta))/(SS.aLN)-1;

PVaHN = (sum(BETA(1:end-1).*(Tr.aHN(1:end-1)-Tr.q(1:end-1).*Tr.aHN(2:end))) + BETA(end)/(1-beta)*Tr.aHN(end)*(1-beta))/(Tr.aHN(1))-1;
PVaLN = (sum(BETA(1:end-1).*(Tr.aLN(1:end-1)-Tr.q(1:end-1).*Tr.aLN(2:end))) + BETA(end)/(1-beta)*Tr.aLN(end)*(1-beta))/(Tr.aLN(1))-1;

% PVreturnHN = (sum(BETA(1:end-1).*(1./Tr.q(1:end-1).*Tr.aHN(2:end))) + BETA(end)/(1-beta)*Tr.aHN(end)/beta)/(Tr.aHN(1)/beta/(1-beta))-1;
% PVreturnLN = (sum(BETA(1:end-1).*(1./Tr.q(1:end-1).*Tr.aLN(2:end))) + BETA(end)/(1-beta)*Tr.aLN(end)/beta)/(Tr.aLN(1)/beta/(1-beta))-1;

% PVreturnHN = (sum(BETA(1:end-1).*(Tr.aHN(2:end))) + BETA(end)/(1-beta)*Tr.aHN(end))/(Tr.aHN(1)/(1-beta))-1;
% PVreturnLN = (sum(BETA(1:end-1).*(Tr.aLN(2:end))) + BETA(end)/(1-beta)*Tr.aLN(end))/(Tr.aLN(1)/(1-beta))-1;

PVreturnHN = (sum(BETA.*Tr.aHN) + BETA(end)*beta/(1-beta)*Tr.aHN(end))/(SS.aHN/(1-beta))-1;
PVreturnLN = (sum(BETA.*Tr.aLN) + BETA(end)*beta/(1-beta)*Tr.aLN(end))/(SS.aLN/(1-beta))-1;

PVCHN = (sum(BETA.*Tr.CHN) + BETA(end)*beta/(1-beta)*Tr.CHN(end))/(SS.cHN/(1-beta))-1;
PVCLN = (sum(BETA.*Tr.CLN) + BETA(end)*beta/(1-beta)*Tr.CLN(end))/(SS.cLN/(1-beta))-1;

%%%%%%%%%%%%%%% Other %%%%%%%%%%%%%%%%%%%%%%%%%%

% Disc = cumprod(Tr.q(1:end-1));
% % ITBC
% LHS_HN = Tr.aHN(1) + Tr.EHN(1)*Tr.wHN(1) +  sum(Disc.*Tr.EHN(2:end).*Tr.wHN(2:end)) + Disc(end)*beta/(1-beta)*Tr.EHN(end).*Tr.wHN(end);
% RHS_HN = Tr.CHN(1) + sum(Disc.*Tr.CHN(2:end)) + Disc(end)*beta/(1-beta)*Tr.CHN(end);
% 
% LHS_LN = Tr.aLN(1) + Tr.ELN(1)*Tr.wLN(1) +  sum(Disc.*Tr.ELN(2:end).*Tr.wLN(2:end))+ Disc(end)*beta/(1-beta)*Tr.ELN(end).*Tr.wLN(end);
% RHS_LN = Tr.CLN(1) + sum(Disc.*Tr.CLN(2:end))+ Disc(end)*beta/(1-beta)*Tr.CLN(end);

%%%%%%%%%%%%%%% Export %%%%%%%%%%%%%%%%%%%%%%%%%%
Stats.Experiment = Experiment;

Stats.wHN = wHN; Stats.wLN = wLN;
Stats.uHN = uHN; Stats.uLN = uLN;
Stats.pH = pH; Stats.pL = pL;

Stats.PVwHN = PVwHN; Stats.PVwLN = PVwLN;
% Stats.PVCHN = PVCHN; Stats.PVCLN = PVCLN;

Stats.lamHNstar = lamHNstar; Stats.lamHN = lamHN; 
Stats.lamLNstar = lamLNstar; Stats.lamLN = lamLN;

% Stats.PVreturnHN = PVreturnHN; Stats.PVreturnLN = PVreturnLN;
% 
% Stats.aHN = aHN; Stats.aLN = aLN;
% 
% Stats.aHNimpact = aHNimpact; Stats.aLNimpact = aLNimpact;
% 
% Stats.PVaHN = PVaHN; Stats.PVaLN = PVaLN;

% Stats.LHS_HN = LHS_HN; Stats.LHS_LN = LHS_LN;
% Stats.RHS_HN = RHS_HN; Stats.RHS_LN = RHS_LN;

end
