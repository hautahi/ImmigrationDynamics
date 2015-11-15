% Zero profit condition, solving for thetas

function Tr = GetTransitionOpenEcon(thetaL,thetaH,flag)
global SS beta eta SS2 alpha A  piLN piLI piHN piHI phi sLI sLN sHI sHN rho bLI bHI bLN bHN kapL kapH delta

n        = length(thetaL);

%%%%%%%%%%%%%%% Finding Rates %%%%%%%%%%%%%%%%%%%%%%%%%%

fL  = GetJF(thetaL); muL = GetVF(thetaL);
fH  = GetJF(thetaH); muH = GetVF(thetaH);

%%%%%%%%%%%%%%% Labor Market %%%%%%%%%%%%%%%%%%%%%%%%%%

ELI = SS.ELI*ones(1,n);
ELN = SS.ELN*ones(1,n);
EHI = SS.EHI*ones(1,n);
EHN = SS.EHN*ones(1,n);

for i = 1:n-1
    ELI(i+1) = ELI(i)*(1-sLI)+fL(i)*(SS2.QLI-ELI(i));
    ELN(i+1) = ELN(i)*(1-sLN)+fL(i)*(SS2.QLN-ELN(i));
    EHI(i+1) = EHI(i)*(1-sHI)+fH(i)*(SS2.QHI-EHI(i));
    EHN(i+1) = EHN(i)*(1-sHN)+fH(i)*(SS2.QHN-EHN(i));
end

%%%
ELI = [ELI(1:end-1) SS2.ELI];
ELN = [ELN(1:end-1) SS2.ELN];
EHI = [EHI(1:end-1) SS2.EHI];
EHN = [EHN(1:end-1) SS2.EHN];
%%%

ULI = SS2.QLI - ELI;
ULN = SS2.QLN - ELN;
UHI = SS2.QHI - EHI;
UHN = SS2.QHN - EHN;

lambdaL = ULI./(ULI+ULN);
lambdaH = UHI./(UHI+UHN);

%%%%%%%%%%%%%%% Goods Market %%%%%%%%%%%%%%%%%%%%%%%%%%

YL = piLN.*ELN + piLI.*ELI; 
YH = piHN.*EHN + piHI.*EHI; 

Z = (phi.*YL.^rho + (1-phi).*YH.^rho).^(1/rho);
K = Z.*(alpha*A/SS.r)^(1/(1-alpha));
Y = A*(K.^alpha).*Z.^(1-alpha);

pL = (1-alpha)*phi*A*(K.^alpha).*(YL.^(rho-1)).*(Z.^(1-rho-alpha));
pH = (1-alpha)*(1-phi)*A*(K.^alpha).*(YH.^(rho-1)).*(Z.^(1-rho-alpha));

%%%%%%%%%%%%%%% Firm Value Functions %%%%%%%%%%%%%%%%%%

r = alpha.*Y./K;
q = 1./(1+[r(2:end), r(end)]-delta);

% odieLI = (1-eta)*(piLI*pL(end)-bLI)/(1-q(end)*(1-sLI-eta*fL(end)));
% odieLN = (1-eta)*(piLN*pL(end)-bLN)/(1-q(end)*(1-sLN-eta*fL(end)));
% odieHI = (1-eta)*(piHI*pH(end)-bHI)/(1-q(end)*(1-sHI-eta*fH(end)));
% odieHN = (1-eta)*(piHN*pH(end)-bHN)/(1-q(end)*(1-sHN-eta*fH(end)));

odieLI = (1-eta)*(piLI*SS2.pL-bLI)/(1-beta*(1-sLI-eta*SS2.fL));
odieLN = (1-eta)*(piLN*SS2.pL-bLN)/(1-beta*(1-sLN-eta*SS2.fL));
odieHI = (1-eta)*(piHI*SS2.pH-bHI)/(1-beta*(1-sHI-eta*SS2.fH));
odieHN = (1-eta)*(piHN*SS2.pH-bHN)/(1-beta*(1-sHN-eta*SS2.fH));

JLI = odieLI*ones(1,n);
JLN = odieLN*ones(1,n);
JHI = odieHI*ones(1,n);
JHN = odieHN*ones(1,n);
for i = n:-1:2
    JLI(i-1) = (piLI.*pL(i-1)-bLI)*(1-eta) + q(i-1)*(1-sLI-eta*fL(i-1))*JLI(i);
    JLN(i-1) = (piLN.*pL(i-1)-bLN)*(1-eta) + q(i-1)*(1-sLN-eta*fL(i-1))*JLN(i);
    JHI(i-1) = (piHI.*pH(i-1)-bHI)*(1-eta) + q(i-1)*(1-sHI-eta*fH(i-1))*JHI(i);
    JHN(i-1) = (piHN.*pH(i-1)-bHN)*(1-eta) + q(i-1)*(1-sHN-eta*fH(i-1))*JHN(i);
end

JLIplus = [JLI(2:end) JLI(end)];
JLNplus = [JLN(2:end) JLN(end)];
JHIplus = [JHI(2:end) JHI(end)];
JHNplus = [JHN(2:end) JHN(end)];

wLI = eta.*(piLI.*pL+q.*fL.*JLIplus)+(1-eta)*bLI;
wLN = eta.*(piLN.*pL+q.*fL.*JLNplus)+(1-eta)*bLN;
wHI = eta.*(piHI.*pH+q.*fH.*JHIplus)+(1-eta)*bHI;
wHN = eta.*(piHN.*pH+q.*fH.*JHNplus)+(1-eta)*bHN;

vL = thetaL.*(ULI+ULN); vH = thetaH.*(UHI+UHN);
d = ELN.*(piLN*pL-wLN) + ELI.*(piLI*pL-wLI) + EHN.*(piHN*pH-wHN) + EHI.*(piHI*pH-wHI) - kapL*vL - kapH*vH;
    
% Solve for Price
price = d(end)/(r(end)-delta)*ones(1,n);
for i = n:-1:2
    price(i-1) = (d(i)+price(i))*q(i-1);
end

%%%%%%% Things to Export %%%%%%%%%%
Tr.JLIplus = JLIplus; Tr.JLNplus = JLNplus;
Tr.JHIplus = JHIplus; Tr.JHNplus = JHNplus;

Tr.lambdaL = lambdaL; Tr.lambdaH = lambdaH;
Tr.muL = muL; Tr.muH = muH;
Tr.vL = vL; Tr.vH = vH;

Tr.K = K; Tr.r=r; Tr.q=q;
Tr.pL = pL; Tr.pH = pH;
Tr.UHN = UHN; Tr.ULN = ULN;
Tr.Z = Z; Tr.YL = YL; Tr.YH = YH; Tr.Y=Y;

%%%%%%%%%%%%%%% Accumulation %%%%%%%%%%%%%%%%%%
% This section calculates asset accumulation variables which are not
% required to solve for labor market variables

if flag == 0
    Disc = cumprod(q(1:end-1));

    % Recalculate initial wealth because of price and dividend change
    temp.aLI = (1+SS.r-delta)*SS.KLI + (price(1)+d(1))*SS.KshareLI;
    temp.aLN = (1+SS.r-delta)*SS.KLN + (price(1)+d(1))*SS.KshareLN;
    temp.aHI = (1+SS.r-delta)*SS.KHI + (price(1)+d(1))*SS.KshareHI;
    temp.aHN = (1+SS.r-delta)*SS.KHN + (price(1)+d(1))*SS.KshareHN;
    
%     RHS_LI=temp.aLI+wLI(1)*ELI(1)+sum(Disc.*wLI(2:end).*ELI(2:end))+Disc(end)*beta/(1-beta)*wLI(end)*ELI(end);
%     RHS_LN=temp.aLN+wLN(1)*ELN(1)+sum(Disc.*wLN(2:end).*ELN(2:end))+Disc(end)*beta/(1-beta)*wLN(end)*ELN(end);
%     RHS_HI=temp.aHI+wHI(1)*EHI(1)+sum(Disc.*wHI(2:end).*EHI(2:end))+Disc(end)*beta/(1-beta)*wHI(end)*EHI(end);
%     RHS_HN=temp.aHN+wHN(1)*EHN(1)+sum(Disc.*wHN(2:end).*EHN(2:end))+Disc(end)*beta/(1-beta)*wHN(end)*EHN(end);  
    
    RHS_LI=temp.aLI+wLI(1)*ELI(1)+sum(Disc.*wLI(2:end).*ELI(2:end))+Disc(end)*beta/(1-beta)*SS2.wLI*SS2.ELI;
    RHS_LN=temp.aLN+wLN(1)*ELN(1)+sum(Disc.*wLN(2:end).*ELN(2:end))+Disc(end)*beta/(1-beta)*SS2.wLN*SS2.ELN;
    RHS_HI=temp.aHI+wHI(1)*EHI(1)+sum(Disc.*wHI(2:end).*EHI(2:end))+Disc(end)*beta/(1-beta)*SS2.wHI*SS2.EHI;
    RHS_HN=temp.aHN+wHN(1)*EHN(1)+sum(Disc.*wHN(2:end).*EHN(2:end))+Disc(end)*beta/(1-beta)*SS2.wHN*SS2.EHN;

    options=optimset('Display','off','TolFun',1e-12,'TolX',1e-9,'MaxIter',500,'MaxFunEvals',50000);
    func_LI = @(x) GetC0(x,RHS_LI,n,q,bLI,ELI);
    func_LN = @(x) GetC0(x,RHS_LN,n,q,bLN,ELN);
    func_HI = @(x) GetC0(x,RHS_HI,n,q,bHI,EHI);
    func_HN = @(x) GetC0(x,RHS_HN,n,q,bHN,EHN);

    [C0LI, errLI, ~] = fsolve(func_LI,0.3,options);
    [C0LN, errLN, ~] = fsolve(func_LN,0.3,options);
    [C0HI, errHI, ~] = fsolve(func_HI,0.3,options);
    [C0HN, errHN, ~] = fsolve(func_HN,0.3,options);
    
    CLI = C0LI*ones(1,n);
    CLN = C0LN*ones(1,n);
    CHI = C0HI*ones(1,n);
    CHN = C0HN*ones(1,n);
    for i = 1:n-1
    CLI(i+1) = beta/q(i)*(CLI(i)-bLI*ELI(i))+bLI*ELI(i+1);
    CLN(i+1) = beta/q(i)*(CLN(i)-bLN*ELN(i))+bLN*ELN(i+1);
    CHI(i+1) = beta/q(i)*(CHI(i)-bHI*EHI(i))+bHI*EHI(i+1);
    CHN(i+1) = beta/q(i)*(CHN(i)-bHN*EHN(i))+bHN*EHN(i+1);
    end

    % Assets
    aLI=(wLI(end)*ELI(end)-CLI(end))/(q(end)-1)*ones(1,n);
    aLN=(wLN(end)*ELN(end)-CLN(end))/(q(end)-1)*ones(1,n);
    aHI=(wHI(end)*EHI(end)-CHI(end))/(q(end)-1)*ones(1,n);
    aHN=(wHN(end)*EHN(end)-CHN(end))/(q(end)-1)*ones(1,n);
    
    for i = n:-1:2
    aLI(i-1) = aLI(i)*q(i-1)-wLI(i-1)*ELI(i-1)+CLI(i-1);
    aLN(i-1) = aLN(i)*q(i-1)-wLN(i-1)*ELN(i-1)+CLN(i-1);
    aHI(i-1) = aHI(i)*q(i-1)-wHI(i-1)*EHI(i-1)+CHI(i-1);
    aHN(i-1) = aHN(i)*q(i-1)-wHN(i-1)*EHN(i-1)+CHN(i-1);
    end
    
    a = aLI + aLN + aHI + aHN;
    
    %%%%%%% Things to Export %%%%%%%%%%

    Tr.thetaL = thetaL; Tr.thetaH = thetaH;    
    Tr.CLI = CLI; Tr.CLN = CLN; Tr.CHI = CHI; Tr.CHN = CHN;
    Tr.ELI = ELI; Tr.ELN = ELN; Tr.EHI = EHI; Tr.EHN = EHN;
    Tr.aLI = aLI; Tr.aLN = aLN; Tr.aHI = aHI; Tr.aHN = aHN;
    Tr.wLI = wLI; Tr.wLN = wLN; Tr.wHI = wHI; Tr.wHN = wHN;
    Tr.price=price; Tr.d=d; Tr.a =a;

end
