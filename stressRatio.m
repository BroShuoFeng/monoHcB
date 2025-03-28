function [Mp, Md, psi] = stressRatio(soil,deOld,e,p,M)
% This function cauculates the peak strength and phase transformation stress ratio
% Inputs in order
% soil - soil parameters
% deOld - volume change due to particle breakage, deOld is always negative
% e -void ratio
% p - mean effective stress
% M - critical stress ratio

lambda=soil(7);
eGAM=soil(9);
pcs=soil(10);
kp=soil(13);
kd=soil(15);

ecs=eGAM-lambda*log(p+pcs) + deOld;
psi = e-ecs;

% ecs2=eGAM-lambda*log(p+pcs) + 0;
% psi2 = e-ecs2;


Mp=M*exp(kp*(-psi));
Md=M*exp(kd*psi);
