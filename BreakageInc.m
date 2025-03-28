function [dEb, dB] = BreakageInc(soil, dWp, xi)
% This function calculates the breakage energy and amount increments
%

beta=soil(19);

dEb = xi*dWp;
dB = beta*dEb;

end

