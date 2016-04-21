function err = GetC0(C0,RHS,n,q,b,E)

global beta 

Disc = cumprod(q(1:end-1));
C = C0*ones(1,n);

for i = 1:n-1
    C(i+1) = beta/q(i)*(C(i)-b*E(i))+b*E(i+1);
end

% LHS = C0 + sum(Disc.*C(2:end))+Disc(end-1)*beta/(1-beta)*C(end);
LHS = C0 + sum(Disc.*C(2:end))+Disc(end)*beta/(1-beta)*C(end);

err = (LHS-RHS);

end
