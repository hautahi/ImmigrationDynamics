function S = SteadyState(thetaL,thetaH,QLN,QLI,QHN,QHI)

global beta eta alpha A  piLN piLI piHN piHI phi sLI sLN sHI sHN rho bLI bHI bLN bHN SS delta kapL kapH

%%%%%%%%%%%%%%% Finding Rates %%%%%%%%%%%%%%%%%%%%%%%%%%

S.thetaH = thetaH; S.thetaL = thetaL;
S.QLN=QLN; S.QLI=QLI; S.QHN=QHN; S.QHI=QHI;
S.Q = S.QHN + S.QLN + S.QHI + S.QLI;

S.fL  = GetJF(S.thetaL); S.fH  = GetJF(S.thetaH);
S.muL = GetVF(S.thetaL); S.muH = GetVF(S.thetaH);

%%%%%%%%%%%%%%% Labor Market %%%%%%%%%%%%%%%%%%%%%%%%%%

S.ELN = S.fL/(sLN+S.fL)*S.QLN; S.ULN = S.QLN - S.ELN;
S.EHN = S.fH/(sHN+S.fH)*S.QHN; S.UHN = S.QHN - S.EHN;

S.ELI = S.fL/(sLI+S.fL)*S.QLI; S.ULI = S.QLI - S.ELI;
S.EHI = S.fH/(sHI+S.fH)*S.QHI; S.UHI = S.QHI - S.EHI;

%%%%%%%%%%%%%%% Goods Market %%%%%%%%%%%%%%%%%%%%%%%%%%

S.YL = piLN*S.ELN + piLI*S.ELI; 
S.YH = piHN*S.EHN + piHI*S.EHI; 

S.Z = (phi*S.YL^rho + (1-phi)*S.YH^rho)^(1/rho);
S.K = S.Z*(alpha*A/SS.r)^(1/(1-alpha));
S.Y = A*S.K^alpha*S.Z^(1-alpha);
S.r = SS.r;

S.pL = (1-alpha)*phi*A*(S.K^alpha)*(S.YL^(rho-1))*(S.Z^(1-rho-alpha));
S.pH = (1-alpha)*(1-phi)*A*(S.K^alpha)*(S.YH^(rho-1))*(S.Z^(1-rho-alpha));

S.lambdaL = S.ULI/(S.ULN+S.ULI);
S.lambdaH = S.UHI/(S.UHN+S.UHI);

%%%%%%%%%%%%%%% Firm Value Functions %%%%%%%%%%%%%%%%%%

S.JLI = (1-eta)*(piLI*S.pL-bLI)/(1-beta*(1-sLI-eta*S.fL));
S.JLN = (1-eta)*(piLN*S.pL-bLN)/(1-beta*(1-sLN-eta*S.fL));

S.JHI = (1-eta)*(piHI*S.pH-bHI)/(1-beta*(1-sHI-eta*S.fH));
S.JHN = (1-eta)*(piHN*S.pH-bHN)/(1-beta*(1-sHN-eta*S.fH));

%%%%%%%%%%%%%%% Wages %%%%%%%%%%%%%%%%%%

S.wLI = eta*(piLI*S.pL+beta*S.fL*S.JLI)+(1-eta)*bLI;
S.wLN = eta*(piLN*S.pL+beta*S.fL*S.JLN)+(1-eta)*bLN;

S.wHI = eta*(piHI*S.pH+beta*S.fH*S.JHI)+(1-eta)*bHI;
S.wHN = eta*(piHN*S.pH+beta*S.fH*S.JHN)+(1-eta)*bHN;

S.vH = S.thetaH*(S.UHI+S.UHN); S.vL = S.thetaL*(S.ULI+S.ULN);
S.d = S.ELN*(piLN*S.pL-S.wLN) + S.ELI*(piLI*S.pL-S.wLI) + S.EHN*(piHN*S.pH-S.wHN) + S.EHI*(piHI*S.pH-S.wHI) - kapL*S.vL - kapH*S.vH;
S.price = S.d/(SS.r-delta);

