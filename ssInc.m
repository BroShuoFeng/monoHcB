function [dsig, deps, du, depsvp, depsqp, dp, dq, depsv, depsq] = ssInc(K, G, H, n, m, Dc, soilName, loadn, subStep, ssControl, drainage, loadInc, stressPath)
% This function calculates the stress and strain increments

if ssControl == 0
        % The compliance matrix C
        C=[1/K+n(1)*m(1)/H,   n(2)*m(1)/H;    n(1)*m(2)/H,   1/(3*G)+n(2)*m(2)/H];%{deps} = C * {dsig}
        % The stiffness matrix T
        T = inv(C);%{dsig} = T * {deps}
        switch drainage
            case 'ISO'
                depsq=0;
                depsv=loadInc;
            case 'CD'
                depsq=loadInc;
                depsv=-(T(1,2)-T(2,2)/stressPath)*depsq/(T(1,1)-T(2,1)/stressPath);
            case 'CU'
                depsv=0;
                depsq=loadInc;
        end
        
        dp=T(1,1)*depsv+T(1,2)*depsq;
        dq=T(2,1)*depsv+T(2,2)*depsq;
        depsqp=depsq-1/3/G*dq;
        depsvrp=depsv-1/K*dp;
elseif ssControl ==1
    dq=loadInc;
        switch drainage
            case 'CD'
                dp=dq/stressPath;
                Lf=Macauley(1/H*(n(1)*dp+n(2)*dq));
            case 'CU'
                Lf=Macauley(n(2)*dq/(H+K*n(1)*m(1)));
                dp=-K*Lf*m(1);
        end
        
        if Lf==0 && subStep~=1
            disp(['Lf = 0 occurs in the # ',num2str(loadn),' th loading event, substep # ',num2str(subStep)])
        end
        depsv=1/K*dp+Lf*m(1);
        depsq=1/3/G*dq+Lf*m(2);
        depsvrp = Lf*m(1);
        depsqp=Lf*m(2);
end
        depsvp=depsvrp+depsqp*Dc;
%           %           %           %           %           %           %
A=[1, 2; 2/3, -2/3];
B=[depsv; depsq];
result=A\B;
deps1=result(1);
deps3=result(2);

A=[1/3, 2/3; 1, -1];
B=[dp; dq];
result=A\B;
dsig1=result(1);
dsig3=result(2);

dsig=[dsig1 dsig3 dsig3];
deps=[deps1 deps3 deps3];
du=dq/stressPath-dp;
