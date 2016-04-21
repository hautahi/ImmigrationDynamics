% Zero profit condition, solving for thetas

function [resid] = GetZP(x,K)
global kapL kapH

thetaL    = real(x(1:length(x)/2).^2);
thetaH    = real(x(length(x)/2+1:end).^2);

Tr        = GetTransition(thetaL,thetaH,K,1);

FFL       = kapL - Tr.q.*Tr.muL.*(Tr.lambdaL.*Tr.JLIplus+(1-Tr.lambdaL).*Tr.JLNplus);
FFH       = kapH - Tr.q.*Tr.muH.*(Tr.lambdaH.*Tr.JHIplus+(1-Tr.lambdaH).*Tr.JHNplus);

FF = [FFL,FFH];

% Note: this is a complementarity problem! See Miranda and Fackler for notes on ways of approaching these
% resid = FF + real(x) - sqrt(FF.^2 + real(x).^2); % Need theta to be positive. This is great
resid =FF;
