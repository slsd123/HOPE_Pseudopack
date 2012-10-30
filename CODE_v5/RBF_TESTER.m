% This programs tests RBF for a given function
clear all; close all; clc


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                          GENERATE THE I/O PATTERN
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

n1=1;
p1=1;
for i=1:27
    if i <15
        Inputs((i-1)*5+1:(i)*5,1) = i/10;
        Ix1(i)=i/10;
    else
        Inputs((i-1)*5+1:(i)*5,1) = i/10+p1*.1;
        Ix1(i)=i/10+p1*.1;
        p1 = p1+1;
        
    end
    Inputs((i-1)*5+1:(i-1)*5+5,2) = [200 600 1000 4000 10000]';
    n1 = n1+1;
end
Iy1 = [200 600 1000 4000 10000];

OutDesired  = [.745 .747 .750 .761 .775 .805 .905 1.10 1.20 1.255 1.277 ...
    1.292 1.302 1.312 1.321 1.330 1.334 1.334 1.340 1.344 1.348 1.352 ...
    1.357 1.360 1.362 1.365 1.365 ...
               .527 .531 .540 .554 .572 .601 .643 .721 .850 1.040 1.086 ...
    1.105 1.113 1.222 1.138 1.152 1.169 1.179 1.190 1.202 1.212 1.222 ...
    1.232 1.241 1.250 1.260 1.267 ...
               .455 .462 .470 .483 .500 .525 .562 .622 .730 .928  1.008 ...
    1.028 1.037 1.047 1.058 1.070 1.080 1.088 1.098 1.110 1.119 1.130 ...
    1.140 1.150 1.160 1.171 1.180 ...
               .388 .410 .403 .420 .440 .465 .510 .568 .650 .800  .915  ...
    0.967 0.988 0.998 1.000 1.000 1.002 1.005 1.012 1.021 1.029 1.040 ...
    1.050 1.060 1.070 1.081 1.092 ...
               .402 .410 .418 .429 .440 .455 .478 .523 .585 .710  0.857 ...
    0.927 0.950 0.959 0.962 0.971 0.978 0.981 0.988 0.994 1.000 1.008 ...
    1.015 1.021 1.028 1.034 1.040]';

% OutDesired  = [.745 .747 .750 .761 .775 ...
%                .527 .531 .540 .554 .572 ...
%                .455 .462 .470 .483 .500 ...
%                .388 .410 .403 .420 .440 ...
%                .402 .410 .418 .429 .440]';

N1=n1;

tempmax = max(OutDesired);

for i=1:135
    Inputs(i,1)=Inputs(i,1)/4;
    Inputs(i,2)=Inputs(i,2)/100000;
    OutDesired(i,1)=OutDesired(i,1)/tempmax;
end

OUTP=OutDesired;



%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                        DESIGN OF THE RADIAL BASIS FUNCTION NETWORK
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

nunitsRBF=125; % No.of Units in the Hidden Layer
% [HidCtrRBF,HidVarRBF,OBWtRBF,OutWtsRBF,ClusterRBF]=UnSupRBF(nunitsRBF,0.02,Inputs,OutDesired,3200,0.01);
[HidCtrRBF,HidVarRBF,OBWtRBF,OutWtsRBF,ClusterRBF]=UnspuerRBF(nunitsRBF,0.02,Inputs,OutDesired,3200,0.001);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                                TESTING THE RBF NETWORK
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

n=length(OUTP);

OutsRBF=OBWtRBF;

map=0.1762706118891446;
rep=1548.201524257457;

for j=1:nunitsRBF
    JNormRBF       = 0;
    d              = map/4-HidCtrRBF(j,1);          %Dis From CTR
    JNormRBF       = JNormRBF+d*d;
    d              = rep/100000-HidCtrRBF(j,2);          %Dis From CTR
    JNormRBF       = JNormRBF+d*d;                       %J-th Norm    
    JNormRBF       = 0.5*JNormRBF/((HidVarRBF(j))^2);
    HidOutRBF      = exp(-1*0.5*JNormRBF);
    OutsRBF        = OutsRBF + OutWtsRBF(j)*HidOutRBF;
end

OutsRBF
cd = (24+.38*rep+4*sqrt(rep))*(1+exp(-.43/(map^4.67)))
