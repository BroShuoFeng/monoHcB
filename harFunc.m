function [h_mul] = harFunc(soil,dPara,e,p)
% A hardening function that incorporates the state-dependent behaviour of sands.
%   Inputs in order

h1=soil(11);
h2=soil(12);

patm=dPara(1);
exponent=dPara(3);

% h_mul = h0*(1-ch*e)*power(p/patm,exponent);

% h_mul = h0*(1-ch*e)*p;%/patm;%*power(p/patm,exponent);
% h_mul = h0*(1-ch*e)/patm;
% h_mul = h1*(1-h2*e);
h_mul = h1 - h2*e;

end