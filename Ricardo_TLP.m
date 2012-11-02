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

tempmax = max(OutDesired)


for i=1:135
    Inputs(i,1)=Inputs(i,1)/4;
    Inputs(i,2)=Inputs(i,2)/100000;
    OutDesired(i,1)=OutDesired(i,1)/tempmax;
end

OUTP=OutDesired;



%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                        DESIGN OF THE TWO LAYER PERCEPTRON NETWORK
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
nunitsTLP1=10; % No.of Units in the First Hidden Layer
nunitsTLP2=20;
[HWts1TLP,HWts2TLP,OWtsTLP,HBWT1TLP,HBWT2TLP,OBWTLP,ErrorTLP,NitTLP]=ThreeLP(nunitsTLP1,nunitsTLP2,0.1,Inputs,OutDesired,3200,0.005);
n=length(OUTP)+1;

% %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% %                                TESTING THE RBF NETWORK
% %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% 

% 
% 
% for i=1:n-1
% 
%     Input(1,1)=Inputs(i,1);
%     Input(1,2)=Inputs(i,2);
%     
%     for j=1:nunitsRBF
%         
%         d(1,1) = Input(1,1)-HidCtrRBF(j,1);  %Dis From CTR
%         d(2,1) = Input(1,2)-HidCtrRBF(j,2);  %Dis From CTR
%         CoVarRBF = HidVarRBF(j);             %jth Covar            
%         JNormRBF(j)= d'*d;                   % J-th Norm
%         JNormRBF(j)=0.5*JNormRBF(j)/((HidVarRBF(j))^2);
%         HidOutRBF(1,j)=exp(-1*0.5*JNormRBF(j));  
%     end
%     
%     OutsRBF=OBWtRBF+OutWtsRBF*HidOutRBF'; %Output Calculated
%     OutsRBF=OutsRBF';                     %For consistency, column vector
%     
%     OutputRBF(i,1)=OutsRBF;
%     
% end
%     
% 
% ErRBF=sqrt((OutDesired-OutputRBF)'*(OutDesired-OutputRBF))/sqrt(OutDesired'*OutDesired);
% 


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                               TESTING THE TLP NETWORK
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

for i=1:(n-1)
    A=[Inputs(i,1),Inputs(i,2)];
    OutputTLP(i,1)=Sigmoid(OBWTLP+(OWtsTLP*Sigmoid(HBWT2TLP+HWts2TLP*Sigmoid(HBWT1TLP+HWts1TLP*A'))));
end

ErTLP=sqrt((OutDesired-OutputTLP)'*(OutDesired-OutputTLP))/sqrt(OutDesired'*OutDesired);

DataPoints=N1-1;

%OUT=[nunitsRBF,DataPoints,ErRBF]
%Inputs=Inputs*180/pi;
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                           TIME FOR NICE COLORFUL PICTURES
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Iy1 = Iy1/100;
[X,Y]=meshgrid(Ix1,Iy1);

imax = length(X(:,1));
jmax = length(X(1,:));

n=1;

for i = 1:imax
    for j = 1:jmax
        ODesired(i,j) = OutDesired(n,1);
        OTLP(i,j)     = OutputTLP(n,1);
        OD(i,j)       = OUTP(n,1);
        n=n+1;
    end
end

%%
figure(1)

subplot(2,2,1)
surf(X,Y,OD)
xlabel('M')
ylabel('Re/100')
zlabel('Drag')
axis([min(Ix1),max(Ix1),min(Iy1),max(Iy1),0.3,1.4])
title(['Empirical Data from Table'])
colorbar

subplot(2,2,3)
surf(X,Y,OTLP)
xlabel('M')
ylabel('Re/100')
zlabel('Drag(Perceptron)')
axis([min(Ix1),max(Ix1),min(Iy1),max(Iy1),0.3,1.4])
title(['NACA'])
colorbar

% subplot(3,2,5)
% surf(X,Y,ODesired)
% xlabel('M')
% ylabel('Re/100')
% zlabel('Drag')
% axis([min(Ix1),max(Ix1),min(Iy1),max(Iy1),0.3,1.4])
% title(['NACA'])
% colorbar

subplot(2,2,2)
contourf(X,Y,OD)
xlabel('M')
ylabel('Re/100')
zlabel('Desired')
title(['Empirical Data from Table'])
colorbar


subplot(2,2,4)
contourf(X,Y,OTLP)
xlabel('M')
ylabel('Re/100')
zlabel('Drag(Perceptron)')
title(['Drag Coefficient-Perceptron'])
colorbar

% subplot(3,2,6)
% contourf(X,Y,ODesired)
% xlabel('M')
% ylabel('Re/100')
% zlabel('Desired')
% title(['Drag Coefficient-Exact'])
% colorbar

