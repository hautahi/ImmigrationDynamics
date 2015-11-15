function U = GetUtil(C,E,b)

global beta 

BETA1 = [1 beta*ones(1, length(C)-1)];
BETA = cumprod(BETA1);
U.t = log(C-b*E);
U.cum = BETA.*U.t;
U.sum = sum(BETA.*U.t);
U.BETA = BETA;

end
