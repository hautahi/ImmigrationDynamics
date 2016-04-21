% This program computes the simulations described in the paper "The Dynamic
% Effects of Immigration" by Hautahi Kingi.

% See www.hautahikingi.com/research for more details

%%-------------------------------------------------------------------------
% 1. Setup
%--------------------------------------------------------------------------

% Housekeeping
clearvars -global
clc; clear; close all; addpath('auxfiles');

% Define globals
global delta alpha piLN piLI piHN piHI rho sLI sLN sHI sHN SS2 beta eta eps kapH bLI bHI SS Target phi bLN bHN xi kapL A

% Exogenous Model Parameters
eta         = 0.5;                 % Nash Bargaining Weight
eps         = 0.5;                 % Matching Function Elasticity
alpha       = 0.33;                % Capital Income Share
rho         = 0.5;                 % Elasticity of sub between high and low skill
delta       = 1 - (1-0.0061)^3;    % Capital Depreciation
beta        = 1/((1+0.0476)^0.25); % Household Discount Rate
SS.r        = 1/beta -(1-delta);   % Steady State Capital Return

% Normalizations
SS.Y = 1; bLN = 0; bHN = 0; kapH = 1;
piLN = 1; piLI = 1; piHN = 1; piHI = 1;

% Directly Matched Statistics
SS.fH = 0.270;  SS.fL = 0.245;                      % Job Finding Rates
SS.QLN = 0.570; SS.QLI = 0.119;                     % Populations 
SS.QHN = 0.261; SS.QHI = 1-SS.QLN-SS.QHN-SS.QLI;    % Populations

% Targets
SS.uLN = 0.087; SS.uLI = 0.081;                     % Unemployment
SS.uHN = 0.034; SS.uHI = 0.045;                     % Unemployment
Target.wHIwHN = 0.9618;                             % HI/HN Wage ratio
Target.wLNwHN = 0.651;                              % LN/HN Wage ratio
Target.wLIwHN = 0.588;                              % LI/HN Wage ratio
Target.KshareLN = 0.036;                            % Capital Shares
Target.KshareLI = 0.012;                            % Capital Shares
Target.KshareHN = 0.867;                            % Capital Shares
Target.KshareHI = 1 - Target.KshareLN - Target.KshareLI - Target.KshareHN;

%%-------------------------------------------------------------------------
% 2. Baseline Calibration
%--------------------------------------------------------------------------

% 1. Solve for Separation Rates
SS.ULN = SS.QLN*SS.uLN; SS.ULI = SS.QLI*SS.uLI;
SS.ELN = SS.QLN - SS.ULN; SS.ELI = SS.QLI - SS.ULI;

SS.UHN = SS.QHN*SS.uHN; SS.UHI = SS.QHI*SS.uHI;
SS.EHN = SS.QHN - SS.UHN; SS.EHI = SS.QHI - SS.UHI;

sLN = SS.fL*SS.ULN/SS.ELN; sLI = SS.fL*SS.ULI/SS.ELI; 
sHN = SS.fH*SS.UHN/SS.EHN; sHI = SS.fH*SS.UHI/SS.EHI; 

% 2. Solve for phi bLN bHN xi kapL
SS.K = alpha*SS.Y/SS.r;

options = optimset('Display','iter','TolFun',1e-12,'TolX',1e-9,'MaxIter',500,'MaxFunEvals',50000);
GetTh   = @(x) Calibration(x);
x0      = [0.5; 0.5; 0.5; 0.5; 0.5];
[x, ~, ~] = fsolve(GetTh,x0,options);

j=1;
phi  = x(j)^2/(1+x(j)^2); j=j+1;
bLI  = x(j); j=j+1;
bHI  = x(j); j=j+1;
xi   = x(j); j=j+1;
kapL = x(j);

% 3. Solve for A
SS.YL = piLN*SS.ELN + piLI*SS.ELI; 
SS.YH = piHN*SS.EHN + piHI*SS.EHI;
SS.Z = (phi*SS.YL^rho + (1-phi)*SS.YH^rho)^(1/rho);
A    = SS.Y/(SS.K^alpha*SS.Z^(1-alpha));

% 4. Solve for thetas
SS.thetaH = (SS.fH/xi)^(1/(1-eps));
SS.thetaL = (SS.fL/xi)^(1/(1-eps));

%%-------------------------------------------------------------------------
% 3. Choose Experiment (reset parameters)
%--------------------------------------------------------------------------

SS2.QLN = SS.QLN; SS2.QLI = SS.QLI;
SS2.QHN = SS.QHN; SS2.QHI = SS.QHI;

% 1a. Homogeneous - Low
% Experiment = 'HomoLow';
% SS2.QLI = SS.QLI+0.01; SS2.QHI = SS.QHI;
% rho = 1; bHI=0; bLI=0; sLN=sHN; sLI=sHN; sHI=sHN; phi=0.5; kapL=1;
% Target.KshareLN = SS.QLN; Target.KshareLI = SS.QLI; Target.KshareHN = SS.QHN;
% Target.KshareHI = 1 - Target.KshareLN - Target.KshareLI - Target.KshareHN;

% 2a. Heterogeneous Wealth - Low
% Experiment = 'HetWealthLow';
% SS2.QLI = SS.QLI+0.01; SS2.QHI = SS.QHI;
% rho = 1; bHI=0; bLI=0; sLN=sHN; sLI=sHN; sHI=sHN; phi=0.5; kapL=1;
% Target.KshareLN = 0.036; Target.KshareLI = 0.012; Target.KshareHN = 0.867;
% Target.KshareHI = 1 - Target.KshareLN - Target.KshareLI - Target.KshareHN;

% 3a. Price Effect - Low
% Experiment = 'PELow';
% SS2.QLI = SS.QLI+0.01; SS2.QHI = SS.QHI;
% rho = 0.5; bHI=0; bLI=0; sLN=sHN; sLI=sHN; sHI=sHN; phi=0.5; kapL=1;
% Target.KshareLN = SS.QLN; Target.KshareLI = SS.QLI; Target.KshareHN = SS.QHN;
% Target.KshareHI = 1 - Target.KshareLN - Target.KshareLI - Target.KshareHN;

% 3b. Price Effect - High
% Experiment = 'PEHigh';
% SS2.QLI = SS.QLI; SS2.QHI = SS.QHI+0.01;
% rho = 0.5; bHI=0; bLI=0; sLN=sHN; sLI=sHN; sHI=sHN; phi=0.5; kapL=1;
% Target.KshareLN = SS.QLN; Target.KshareLI = SS.QLI; Target.KshareHN = SS.QHN;
% Target.KshareHI = 1 - Target.KshareLN - Target.KshareLI - Target.KshareHN;

% 4a. Outside Options - Low
% Experiment = 'bLow';
% SS2.QLI = SS.QLI+0.01; SS2.QHI = SS.QHI;
% rho = 1; phi=0.5;
% Target.KshareLN = SS.QLN; Target.KshareLI = SS.QLI; Target.KshareHN = SS.QHN;
% Target.KshareHI = 1 - Target.KshareLN - Target.KshareLI - Target.KshareHN;

% 4b. Outside Options - High
% Experiment = 'bHigh';
% SS2.QLI = SS.QLI; SS2.QHI = SS.QHI+0.01;
% rho = 1; phi=0.5;
% Target.KshareLN = SS.QLN; Target.KshareLI = SS.QLI; Target.KshareHN = SS.QHN;
% Target.KshareHI = 1 - Target.KshareLN - Target.KshareLI - Target.KshareHN;

% 4a. Main - Low
Experiment = 'MainLow';
SS2.QLI = SS.QLI+0.01; SS2.QHI = SS.QHI;

% 4b. Main - High
% Experiment = 'MainHigh';
% SS2.QLI = SS.QLI; SS2.QHI = SS.QHI+0.01;

%%-------------------------------------------------------------------------
% 4. Calculate Initial Steady State
%--------------------------------------------------------------------------

% Calculate Thetas
GetTh     = @(x) GetTheta(x,SS.QLN,SS.QLI,SS.QHN,SS.QHI);
 x0       = [SS.thetaL; SS.thetaH];
[x, ~, ~] = fsolve(GetTh,x0,options);
SS.thetaL = x(1); SS.thetaH = x(2);

% Calculate Labor Market Variables
SS = SteadyState(SS.thetaL, SS.thetaH, SS.QLN, SS.QLI, SS.QHN, SS.QHI);

% Calculate Wealth and Consumption Variables
SS.KshareLN = Target.KshareLN; SS.KshareLI = Target.KshareLI; SS.KshareHN = Target.KshareHN;
SS.KshareHI = 1 - SS.KshareLN - SS.KshareLI - SS.KshareHN;

SS.KLN = SS.KshareLN*SS.K; SS.KLI = SS.KshareLI*SS.K;
SS.KHN = SS.KshareHN*SS.K; SS.KHI = SS.KshareHI*SS.K;

SS.aLN = (1+SS.r-delta)*SS.KLN+(SS.price+SS.d)*SS.KshareLN;
SS.aLI = (1+SS.r-delta)*SS.KLI+(SS.price+SS.d)*SS.KshareLI;

SS.aHN = (1+SS.r-delta)*SS.KHN+(SS.price+SS.d)*SS.KshareHN;
SS.aHI = (1+SS.r-delta)*SS.KHI+(SS.price+SS.d)*SS.KshareHI;

SS.a = SS.aLN+SS.aLI+SS.aHN+SS.aHI;

SS.cLN = SS.wLN*SS.ELN +SS.aLN*(1-beta);
SS.cLI = SS.wLI*SS.ELI +SS.aLI*(1-beta);

SS.cHN = SS.wHN*SS.EHN +SS.aHN*(1-beta);
SS.cHI = SS.wHI*SS.EHI +SS.aHI*(1-beta);

SS.check = SS.Y - (SS.cLN+SS.cLI+SS.cHN+SS.cHI) - (kapL*SS.vL+kapH*SS.vH) - delta*SS.K

%% ------------------------------------------------------------------------
% 5. Calculate Final Steady State
%--------------------------------------------------------------------------

options = optimset('Display','iter','TolFun',1e-12,'TolX',1e-9,'MaxIter',500,'MaxFunEvals',50000);
GetTh   = @(x) GetTheta(x,SS2.QLN,SS2.QLI,SS2.QHN,SS2.QHI);
x0      = [SS.thetaL; SS.thetaH];
[x, err1, eflag] = fsolve(GetTh,x0,options);
SS2.thetaL = x(1); SS2.thetaH = x(2);

SS2 = SteadyState(SS2.thetaL,SS2.thetaH,SS2.QLN,SS2.QLI,SS2.QHN,SS2.QHI);

SS2.Q = SS2.QHN + SS2.QLN + SS2.QHI + SS2.QLI;

%% ------------------------------------------------------------------------
% 6a. Open Economy (q=beta)
%--------------------------------------------------------------------------

% Solve
T = 250;
x0 = [SS2.thetaL*ones(1,T), SS2.thetaH*ones(1,T)];

func1 = @(x) GetZPOpenEcon(x);
[x, err, ~] = fsolve(func1,x0,options);
Open.thetaL    = real(x(1:length(x)/2).^2);
Open.thetaH    = real(x(length(x)/2+1:end).^2);

Open = GetTransitionOpenEcon(Open.thetaL,Open.thetaH,0);

% Get Stats
OpenStats = GetStats(Open,Experiment);

%% ------------------------------------------------------------------------
% 6a. Closed Economy
%--------------------------------------------------------------------------

% Solve
options = optimset('Display','off','TolFun',1e-12,'TolX',1e-9,'MaxIter',500,'MaxFunEvals',50000);
K_step = (max(SS2.K,SS.K)-min(SS2.K,SS.K))/(T-1);
Kgrid0  = SS.K : K_step : SS2.K;
x = x0;
iter = 0; dist = 1;
while (dist > 0.0001 && iter < 800)
    
    % Reset grid of K
    Kgrid  = Kgrid0;
    
    % Solve for given grid of K
    func = @(x) GetZP(x,Kgrid);
    [x, err, ~] = fsolve(func,x,options);

    thetaL    = real(x(1:length(x)/2).^2);
    thetaH    = real(x(length(x)/2+1:end).^2);
    
    Closed = GetTransition(thetaL,thetaH,Kgrid,0);
    
    Kgrid0 = (0.1*Closed.Kagg+0.9*Kgrid);
    
    dist = max(abs(Closed.Kagg-Kgrid)); iter = iter+1;
    fprintf('iter %3i: dist = %9.6f\n', iter, dist)
    
end

% Get Stats
ClosedStats = GetStats(Closed,Experiment);

%% ------------------------------------------------------------------------
% . Plot and Save
%--------------------------------------------------------------------------

OpenStats
ClosedStats
LaborPlots

%% -------------------------------------------------------------------------
% 6. Save
%--------------------------------------------------------------------------

fnameClosed = strcat('output/stats/',Experiment,'Closed','.mat');
save(fnameClosed,'ClosedStats');

fnameOpen = strcat('output/stats/',Experiment,'Open','.mat');
save(fnameOpen,'OpenStats');

fnameGraph = strcat('output/',Experiment);
set(gcf, 'Position', get(0,'Screensize'),'PaperPositionMode','auto'); 
saveas(gcf,fnameGraph,'jpg')

% Gather
odie = [fieldnames(ClosedStats), struct2cell(OpenStats)]
GatherStats = [struct2table(OpenStats); struct2table(ClosedStats)];
writetable(GatherStats,'Stats.csv')

%% -------------------------------------------------------------------------
% . Aggregate Plots
%--------------------------------------------------------------------------
fs = 12; lw = 2; i=1; rows = 2; cols = 3;
figure('Position', [100,100,800,600])
T=2*length(Closed.thetaH);

subplot(rows,cols,i), plot((Open.K(1:T/2-50)-SS.K)/SS.K,'--r', 'LineWidth', lw)
    hold on
    plot((Closed.K(1:T/2-50)-SS.K)/SS.K,'-b', 'LineWidth', lw)
	set(gca, 'FontSize', fs)
    title('Aggregate Capital')
    legend('Open Economy','Closed Economy')
    xlabel('Time')
    ylabel('Percentage Deviation')
    i=i+1;
    
subplot(rows,cols,i), plot((Open.Y(1:T/2-50)/SS2.Q-SS.Y/SS.Q)/(SS.Y/SS.Q),'--r', 'LineWidth', lw)
    hold on
    plot((Closed.Y(1:T/2-50)/SS2.Q-SS.Y/SS.Q)/(SS.Y/SS.Q),'-b', 'LineWidth', lw)
	set(gca, 'FontSize', fs)
    title('Per Capita Output')
    legend('Open Economy','Closed Economy')
    xlabel('Time')
    ylabel('Percentage Deviation')
    i=i+1;
    
subplot(rows,cols,i), plot((Open.aHN(1:T/2-50)-SS.aHN)/SS.aHN,'--r', 'LineWidth', lw)
    hold on
    plot((Closed.aHN(1:T/2-50)-SS.aHN)/SS.aHN,'-b', 'LineWidth', lw)
	set(gca, 'FontSize', fs)
    title('High Skill Native Wealth')
    legend('Open Economy','Closed Economy')
    xlabel('Time')
    ylabel('Percentage Deviation')
    i=i+1;
    
 subplot(rows,cols,i), plot((Open.d(1:T/2-50)-SS.d)/SS.d,'--r', 'LineWidth', lw)
    hold on
    plot((Closed.d(1:T/2-50)-SS.d)/SS.d,'-b', 'LineWidth', lw)
	set(gca, 'FontSize', fs)
    title('Dividends')
    legend('Open Economy','Closed Economy')
    xlabel('Time')
    ylabel('Percentage Deviation')
    i=i+1;
    
subplot(rows,cols,i), plot((1./Open.q(1:T/2-50)-1/beta)/(1/beta),'--r', 'LineWidth', lw)
    hold on
    plot((1./Closed.q(1:T/2-50)-1/beta)/(1/beta),'-b', 'LineWidth', lw)
	set(gca, 'FontSize', fs)
    title('Asset Return')
    legend('Open Economy','Closed Economy')
    xlabel('Time')
    ylabel('Percentage Deviation')
    i=i+1;
    
subplot(rows,cols,i), plot((Open.aLN(1:T/2-50)-SS.aLN)/SS.aLN,'--r', 'LineWidth', lw)
    hold on
    plot((Closed.aLN(1:T/2-50)-SS.aLN)/SS.aLN,'-b', 'LineWidth', lw)
	set(gca, 'FontSize', fs)
    title('Low Skill Native Wealth')
    legend('Open Economy','Closed Economy')
    xlabel('Time')
    ylabel('Percentage Deviation')
    i=i+1;
return
% Save
fnameGraph = strcat('output/',Experiment,'Agg');
set(gcf, 'Position', get(0,'Screensize'),'PaperPositionMode','auto'); 
saveas(gcf,fnameGraph,'fig')
