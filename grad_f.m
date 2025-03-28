function [hf,np,nq] = grad_f(soil, nPara, sur_f, sig, gT)
%This function calculates the hardening multipler and the plastic loading direction n(np, nq)

% Parameters
tiny = nPara(2);

Mc=soil(3);
n=soil(5);
r=soil(6);

M=Mc*gT;

% Back-stress
alphap = sur_f(1);
alphaq = sur_f(2);
a = sur_f(3);

% Stress state variables
p=sig(1);
q=sig(2);
pbar=(p-alphap+tiny);
qbar=(q-alphaq+tiny);
etabar=(q-alphaq)/(p-alphap);

% Derivatives
dfdp=-n/pbar*power(etabar/M,n)+1/pbar/log(r);
dfdq=n/qbar*power(etabar/M,n);
dfda=-1/a/log(r);

%loading directions
np=dfdp/sqrt(dfdp^2+dfdq^2);
nq=dfdq/sqrt(dfdp^2+dfdq^2);

hf=dfda/sqrt(dfdp^2+dfdq^2);

end
