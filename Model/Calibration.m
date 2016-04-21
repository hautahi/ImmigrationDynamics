function err = Calibration(x)

global alpha piLN piLI piHN piHI sLI sLN sHI sHN rho beta eta eps kapH bLN bHN SS Target

j=1;
phi  = x(j)^2/(1+x(j)^2); j=j+1;
% bLN  = x(j); j=j+1;
% bHN  = x(j); j=j+1;
bLI  = x(j); j=j+1;
bHI  = x(j); j=j+1;
xi   = x(j);j=j+1;
kapL = x(j);

% Output
YL = piLN*SS.ELN + piLI*SS.ELI; 
YH = piHN*SS.EHN + piHI*SS.EHI;

lambdaL = SS.ULI/(SS.ULN+SS.ULI);
lambdaH = SS.UHI/(SS.UHN+SS.UHI);

thetaL = (SS.fL/xi)^(1/(1-eps));
muL = SS.fL/thetaL;

thetaH = (SS.fH/xi)^(1/(1-eps));
muH = SS.fH/thetaH;

Z = (phi*YL^rho + (1-phi)*YH^rho)^(1/rho);

A    = SS.Y/(SS.K^alpha*Z^(1-alpha));

pL = (1-alpha)*phi*A*(SS.K^alpha)*(YL^(rho-1))*(Z^(1-rho-alpha));
pH = (1-alpha)*(1-phi)*A*(SS.K^alpha)*(YH^(rho-1))*(Z^(1-rho-alpha));

%%%%%%%%%%%%%%% Firm Value Functions %%%%%%%%%%%%%%%%%%

JLI = (1-eta)*(piLI*pL-bLI)/(1-beta*(1-sLI-eta*SS.fL));
JLN = (1-eta)*(piLN*pL-bLN)/(1-beta*(1-sLN-eta*SS.fL));

JHI = (1-eta)*(piHI*pH-bHI)/(1-beta*(1-sHI-eta*SS.fH));
JHN = (1-eta)*(piHN*pH-bHN)/(1-beta*(1-sHN-eta*SS.fH));

%%%%%%%%%%%%%%% Wages %%%%%%%%%%%%%%%%%%

wLI = eta*(piLI*pL+beta*SS.fL*JLI)+(1-eta)*bLI;
wLN = eta*(piLN*pL+beta*SS.fL*JLN)+(1-eta)*bLN;

wHI = eta*(piHI*pH+beta*SS.fH*JHI)+(1-eta)*bHI;
wHN = eta*(piHN*pH+beta*SS.fH*JHN)+(1-eta)*bHN;

err(1) = wLI-Target.wLIwHN*wHN;
err(2) = wHI-Target.wHIwHN*wHN;
err(3) = wLN-Target.wLNwHN*wHN;
err(4) = kapL - beta*muL*(lambdaL*JLI+(1-lambdaL)*JLN);
err(5) = kapH - beta*muH*(lambdaH*JHI+(1-lambdaH)*JHN);

