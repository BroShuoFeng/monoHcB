drainage='CU';
disp(['Drainage condition: ',drainage])
ssControl = 0; % 0 for strain-control, 1 for stress-control

% Initial state variables
sig0 = [
            3000 3000 3000;
            3000 3000 3000;
            3000 3000 3000;
            2000 2000 2000;
            ];

void0=[
            0.798;
            0.870;
            0.924;
            0.798;
            ];

% Breakage index
B0 = [
        0.0130;
        0.0124;
        0.0117;
        0.0102;
     ];

% loadN = total number of loading events
[monNum, ~] = size(void0);
eps0 = zeros(monNum,3);


% loadqpR = dq / dp, loading paths
loadqpR = 3*ones(monNum,1);
qave=0;

% loadb = (sig2-sig3)/(sig1-sig3)
loadb = zeros(monNum,1);%triaxial compression

% loadR = Stress reversal for cyclic loading, or, deviatoric strain amplitudes for monotonic loading
loadR = 0.20*ones(monNum,1);
