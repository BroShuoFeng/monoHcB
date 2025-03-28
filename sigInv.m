function [p, q, theta] = sigInv(sig)
% This function calculates the stress invariants
% Input :
% sig - [ sigma_1, sigma_2, sigma_3 ]
%
% Outputs :
% p
% q
% theta

p = 1/3*(sig(1)+sig(2)+sig(3));
q = 1/sqrt(2)*sqrt( (  sig(1) - sig(2) )^2 + (  sig(2) - sig(3) )^2 + ( sig(3) - sig(1) )^2      );
b = ( sig(2) - sig(3) )  /  ( sig(1) - sig(3) );
theta = atand((2*b-1)/sqrt(3));

end