function[K ,G] = eModuli (e, p, pc, kappa, nu)
% This function calculates the elastic moduli K and G
%
% Inputs in order :
% e - void ratio
% p - mean effective stress
% pc - compressive stress
% kappa - slope of the unloading line
% nu - Poisson's ratio
%
% Outputs in order :
% K - 
% G -

K=(1+e)*(p+pc)/kappa;
G=3*(1-2*nu)/2/(1+nu)*K;
