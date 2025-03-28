function [gT] = gTheta(b, c, dPara)
% This function calculates the value of g(theta), i.e., interpolation of the
% frinctional coefficient Mc with different Lode's angle (or b, b = ( sig2-sig3 ) / (sig1-sig3) )
% inputs in order :
% - theta in degree
% - c = Mext / Mcom, c should be larger than about 0.75

if b~=0 && b~=1
    c < 0.7;
    error('The gTheta function is not good')
end

tiny=dPara(3);
theta = atan((2*b-1)/sqrt(3));

if theta == 0
    theta=tiny;
end

gT=(   sqrt((1+c^2)^2+4*c*(1-c^2)*sin(3*theta))-(1+c^2)  )/(  2*(1-c)*sin(3*theta)    );