% Numerical implementation for the High-cycle Breakage model
clc;
clear;

disp('===========================================')
disp('                      #        #        #        #        #        #        #')
disp('                      #       High-cycle Breakage model       #')
disp('                      #       version for monotonic loading   #')
disp('                      #        #        #        #        #        #        #')
disp('===========================================')
disp(' ')
disp('    Authored by :')
disp('          Shuo Feng')
disp('              Ph. D. candidate')
disp('              Department of Geotechnical Engineering')
disp('              Beijing Jiaotong University')
disp('              E-mail address : shuoFeng@bjtu.edu.cn')
disp(' ')
disp('===========================================')
disp(' ')
disp('   Code information')
disp('          Created : Jul. 31, 2024')
disp('          Accomplished : Oct. 31, 2024')
disp(' ')
disp('===========================================')

disp('===========================================')
disp('Declaration of dimension')
disp(' ')
disp('Time : none')
disp('Stress : kilopascal')
disp('Strain : none')
disp(' ')
disp('===========================================')

%% Some declarations
disp('===========================================')
disp(' ')
disp('The following contents should be noticed by users !')
disp(' ')
disp('# 1: None.')
disp(' ')
disp('===========================================')

%% Default parameters
defaultPara;

%% Numerical setting
numSet;

%% Data Storage
sample = 1; %sample = Number of column for data storage
loadN = 4; %loadN = Number of loading events in each column

SIG = cell(loadN,sample); %stress state variables
EPS = cell(loadN,sample); %strain state variables
EWP = cell(loadN,sample); %excess porewater pressure
BI = cell(loadN,sample); %breakage index
DR = cell(loadN,sample); %dilatancy ratio
ENERGY = cell(loadN,sample); %energy variables
DATA = cell(loadN,sample); %other variables

tic;

for sam = 1% sam = 1 is for monotonic drained triaxial shear test
                   % sam = 2 is for monotonic undrained triaxial shear test
    soil_CoralSandFinal;
    
    %% Integration
    disp('')
    disp('#   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #')
    disp('')
    disp('')
    disp(['Simulation of the ',num2str(sam),' th sample started.'])
    disp('')
    disp('')
    disp('#   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #')
    disp('')
    
    for loadn=1:loadN
        
        disp('= = = = = = = = = = = = = = = = = = = = = = =')
        disp(['Simulation No.', num2str(sam),', loading event No. ',num2str(loadn),', started.'])
        disp('Integrating . . .')
        disp('')
        
        % Assigning the initial state varables and loading condition
        if ssControl ==0 || (ssControl ==1 && loadn==1)
            sigOld=sig0(loadn,:);
            epsOld=eps0(loadn,:);
            uOld=0;
            bi = B0(loadn);
            D=0;
            Wp = [0, 0, 0];
            da = [0 0];
            deOld=0;
            epsqOld=[0; 0];
            e0=void0(loadn);
            ratio = [1, 1];
        end
        
        if ssControl == 0
            loadAmp=loadR(loadn)-2/3*(epsOld(1)-epsOld(3));
        else
            loadAmp=loadR(loadn)-(sigOld(1)-sigOld(3));
        end
        b=loadb(loadn);
        stressPath = loadqpR(loadn);
        switch soilName
            case 'CoralSand'
                if loadn>1
                    nPara(1)=400;
                end
        end
        
        Step=nPara(1);
        % Resetting the state variables
        sig=zeros(Step,3);
        eps=zeros(Step,3);
        ewp=zeros(Step,1);
        Bi = zeros(Step,1);
        dr=zeros(Step,1);
        energy=zeros(Step,3);
        data=zeros(Step,2);
        
        for subStep=1:Step
            
            % Data storage
            sig(subStep,:)=sigOld;
            eps(subStep,:)=epsOld;
            ewp(subStep,:)=uOld;
            Bi(subStep,:)=bi;
            dr(subStep,:)=D;
            energy(subStep,:)=Wp;
            data(subStep,:)=da;
            
            % Applying a harmonic loading increment, instead of using loadInc=loadAmp/Step;
            f1=0.5*(sin((subStep-1)/Step*pi-pi/2)+1);
            f2=0.5*(sin((subStep)/Step*pi-pi/2)+1);
            loadInc=loadAmp*(f2-f1);
            
            [sigNew,epsNew,uNew,deNew,epsqNew,Wp,bi,D,H,da]=...
                HcB_sub (soilName,loadn,subStep,soil,dPara,nPara,ssControl,drainage,...
                stressPath,b,loadInc,e0,sigOld,epsOld,uOld,deOld,epsqOld,Wp,bi);
            
            if ssControl == 1 && H <= 0
                warning(['Integration aborted at loading event #',num2str(loadn),' substep # ',num2str(subStep)])
                break
            end
            
            sigOld=sigNew;
            epsOld=epsNew;
            uOld=uNew;
            deOld=deNew;
            epsqOld=epsqNew;
            
        end
        
        if bi > 1
            disp(['Abort at the Simulation No.', num2str(sam), 'loadning event # ',num2str(loadn)])
            error('Breakage index exceeds one !')
        end
        
        
        SIG(loadn,sam)={sig};
        EPS(loadn,sam)={eps};
        EWP(loadn,sam)={ewp};
        BI(loadn,sam)={Bi};
        DR(loadn,sam)={dr};
        ENERGY(loadn,sam)={energy};
        DATA(loadn,sam)={data};
        
        disp(['Simulation No.', num2str(sam),', loading event No. ',num2str(loadn),', ended.'])
        disp('= = = = = = = = = = = = = = = = = = = = = = =')
        disp(' ')
    end
    
    if ssControl == 0
        voidR0=void0.*ones(monNum,1);
    else
        voidR0=void0.*ones(loadN,1);
    end
    
    disp('#   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #')
    disp('')
    disp('')
    disp('')
    disp(['Simulation of the ',num2str(sam),' th sample ended.'])
    disp('')
    disp('')
    disp('')
    disp('#   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #')
    
end

%%
disp(' ')
disp('= = = = = = = = = = = = = = = = = = = = = = =')

toc;

disp('= = = = = = = = = = = = = = = = = = = = = = =')
disp(' ')

disp('===========================================')
disp('                      #        #        #        #        #        #        #')
disp('                      #          Integration completed !          #')
disp('                      #        #        #        #        #        #        #')
disp('===========================================')
disp(' ')
disp(['                                                                          ',datestr(now)]);

