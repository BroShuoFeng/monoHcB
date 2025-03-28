soilName = 'CoralSand';% tested by Yu, Fangwei';
disp('soilName');

soil=[
    % Parameters for the virgin loading
    0.04;      % kappa
    0.25;        % nu
    1.5;        % Mc
    0.8;        % c = Mext / Mcom
    2;          % n
    
    %           %           %           %           %           %           %
    4.17;      % r
    0.25;      % lambda
    2.9914;        % eN
    2.6914;        % eGAM
    200;        % pcs
    %           %           %           %           %           %           %
    
    15;              % h1
    10.8;         % h2
    1.2;           % kp
    1;              % d0
    2.5;           % kd

    % Parameters for cyclic loading
    10;    % rho
    0.2;     % xi0
    190;    % zeta% larger value of zeta leads to a lower B value
    0.005;     % beta
    ];

%% Loading scheme

if sam == 1
    CoralSandMonCD;
    nPara(1) = 1000;
elseif sam == 2
    CoralSandMonCU;
    nPara(1) = 1000;
else
    disp('ERROR - undefined loading type')
    disp('        execution aborted')
    disp('        soil_CoralSandFinal')
    error(' ')
end

