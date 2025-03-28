function [Dr, Dc] = DilatancyR(loadn, soil, subStep, xi, eta, ce, Md)
% Rowe's stress-dilatancy relation with the consideration of particle
% breakage energy

d0=soil(14);

Dr = d0*ce*9*(Md-eta)/(9+3*Md-2*eta*Md);

% A = abs(      (9-3*Md)/(9+3*Md-2*eta*Md)*(6+4*Md)/(6+Md)      );
A = (9-3*abs(Md))/(9+3*abs(Md)-2*abs(eta*Md))*(6+4*abs(Md))/(6+abs(Md));

% D = (Dr+xi*eta*A)/(1-xi*A);
% Dc = D - Dr;
Dc = xi*A*(Dr + eta)/(1-xi*A);

if Dc < 0
    disp(['Abort at the loadning event # ',num2str(loadn), ' substep # ',num2str(subStep)])
    error('Negative Dc occurs !')
end

end

