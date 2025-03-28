function [sigNew,epsNew,uNew,deNew,epsqNew,Wp,bi,Dr,H,da]=...
    HcB_sub (soilName,loadn,subStep,soil,dPara,nPara,ssControl,drainage,...
    stressPath,b,loadInc,e0,sigOld,epsOld,uOld,deOld,epsqOld,Wp,bi)
%% Default parameters
pref=dPara(2);

%% Soil parameters
kappa=soil(1);
nu=soil(2);
Mc=soil(3);
c=soil(4);
n=soil(5);
r=soil(6);
lambda=soil(7);
eN=soil(8);
eG=soil(9);
pcs=soil(10);
h1=soil(11);
h2=soil(12);
kp=soil(13);
d0=soil(14);
kd=soil(15);
rho=soil(16);
xi0=soil(17);
zeta=soil(18);
beta=soil(19);

pc=(pcs+pref)*exp((eN-eG)/lambda)-pref;
chi=(1+e0)/(lambda-kappa);

%% Current state variables
[p, ~, ~]=sigInv(sigOld);
q=sigOld(1)-sigOld(3);
eta=q/p;

if b==0
    ce=1;
elseif b==1
    ce=-1;
end

[gT] = ce*gTheta(b, c, dPara);

%% Characteristic shear stress ratios
e=e0-sum(epsOld)*(1+e0);
[Mp, Md, ~] = stressRatio(soil,deOld,e,p,Mc*gT);

%% Elastic moduli
[K, G]=eModuli(e, p, pc, kappa, nu);

%% The current loading and bounding surface
    af=p*power(r,power(q/p/(Mc*gT),n));
    surfaceY = [0, 0, af];
    surfaceB = surfaceY;

%% Loading direction
[~, np, nq] = grad_f(soil,nPara,surfaceY,[p,q],gT);
npq=[np; nq];

%% Image point and the conjugate hardening multiplier at that point
sigB=[p, q];
[hF, ~, ~] = grad_f(soil,nPara,surfaceB,sigB,gT);

%% Particle crushing potential
xi = xi0*(1+zeta*epsqOld(1))/(1+zeta*epsqOld(2));

%% Dilatancy and plastic flow directions
[Dr, Dc] = DilatancyR(loadn, soil, subStep, xi, eta, ce, Md);
mpq=[Dr; ce];

%% The plastic modulus
hmul = harFunc(soil,dPara,e,p);
H=1/3*(Dr+2)*ce*(Mp-eta)*hmul*(-hF)*chi*(surfaceB(3)+pc);

%% Update state variables through stress-strain matrix
[dsig, deps, du, depsvp, depsqp, ~, ~, depsv, depsq] = ssInc(K, G, H, npq, mpq, Dc, soilName, loadn, subStep, ssControl, drainage, loadInc, stressPath);

sigNew=sigOld+dsig;
epsNew=epsOld+deps;
uNew=uOld+du;

depsvcp = abs(depsqp)*Dc;
de=-(1+e0)*depsvcp;
deNew=deOld+de;
epsqNew = epsqOld + [depsvcp;  abs(depsqp)];

%% Breakage increments
dWp = p*depsvp+q*depsqp;
dW = p*depsv+q*depsq;
[dEb, dB] = BreakageInc(soil, dWp, xi);
Wp = Wp+[dWp, dW, dEb];
bi = bi + dB;

%% Data storage
da=[xi af];

end
