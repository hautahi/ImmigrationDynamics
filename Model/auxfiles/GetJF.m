function [fval] = GetJF(theta)
global xi eps

fval = min( xi*theta.^(1-eps), ones(size(theta,1),1) );
end
