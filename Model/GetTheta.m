function err = GetTheta(x,QLN,QLI,QHN,QHI)

global beta kapL kapH 

thetaL = x(1); thetaH = x(2);

S = SteadyState(thetaL,thetaH,QLN,QLI,QHN,QHI);

err(1) = kapL-beta*S.muL*(S.lambdaL*S.JLI+(1-S.lambdaL)*S.JLN);
err(2) = kapH-beta*S.muH*(S.lambdaH*S.JHI+(1-S.lambdaH)*S.JHN);
end
