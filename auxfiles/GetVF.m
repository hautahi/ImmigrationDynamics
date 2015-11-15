function [fval] = GetVF(theta)
global xi eps

fval = min( xi*theta.^(-eps), ones(size(theta,1),1) );

end
