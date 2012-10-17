% This programs tests RBF for a given function
clear all; clc;% close all;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                          GENERATE THE I/O PATTERN
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
train_pts = 150;
test_pts  = 150;
nunitsRBF = 5000; % No.of Units in the Hidden Layer

n1=1;
p1=1;

Ix1 = 0.1:(4    -0.1)/(train_pts-1):4    ;
Iy1 = 200:(10000-200)/(train_pts-1):10000;
max1 = max(Ix1);
Ix1  = Ix1/max1;
max2 = max(Iy1);
Iy1  = Iy1/max2;

for i = 1:length(Iy1)
    Inputs(length(Ix1)*(i-1)+1:length(Ix1)*i,1) = Ix1;
end
for i = 1:length(Iy1)
    Inputs(length(Ix1)*(i-1)+1:length(Ix1)*i,2) = Iy1(i);
end

for i=1:length(Inputs(:,1))
    map = Inputs(i,1)*max1;
    rep = Inputs(i,2)*max2;

    OutDesired(i,1) = (24.0/rep+0.38+4.0/sqrt(rep))*...
        (1.0+exp(-0.43/(map^4.67)));
end
max3 = max(OutDesired);
OutDesired = OutDesired/max3;

N1=n1;

OUTP=OutDesired;
%%
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                        DESIGN OF THE RADIAL BASIS FUNCTION NETWORK
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
a = 'Begin building ANN'
tic
% [HidCtrRBF,HidVarRBF,OBWtRBF,OutWtsRBF,ClusterRBF]=...
%     UnSupRBF(nunitsRBF,0.02,Inputs,OutDesired,3200,0.01);
[HidCtrRBF,HidVarRBF,OBWtRBF,OutWtsRBF,ClusterRBF]=...
    UnspuerRBF(nunitsRBF,0.02,Inputs,OutDesired,3200,0.001);
toc
a = 'ANN Built'
%
%%
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                                TESTING THE RBF NETWORK
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
[X,Y]=meshgrid(Ix1,Iy1);

Ix2 = 0.1:(4    -0.1)/(test_pts-1):4    ;
Iy2 = 200:(10000-200)/(test_pts-1):10000;

max1 = max(Ix2);
Ix2 = Ix2/max1;
max2 = max(Iy2);
Iy2 = Iy2/max2;

for i = 1:length(Iy2)
    Inputs2(length(Ix2)*(i-1)+1:length(Ix2)*i,2) = Iy2(i);
end
for i = 1:length(Iy2)
    Inputs2(length(Ix2)*(i-1)+1:length(Ix2)*i,1) = Ix2;
end


a = 'Building grid'
tic
% for i=1:length(Ix2)*length(Iy2)
% 
%     Input(1,1)=Inputs2(i,1);
%     Input(1,2)=Inputs2(i,2);
%     
%     map = Inputs2(i,1)*max1;
%     rep = Inputs2(i,2)*max2;
%     
%     OutsRBF=OBWtRBF;
%     
%     for j=1:nunitsRBF
%         JNormRBF       = 0;
%         d              = Input(1,1)-HidCtrRBF(j,1);          %Dis From CTR
%         JNormRBF       = JNormRBF+d*d;
%         d              = Input(1,2)-HidCtrRBF(j,2);          %Dis From CTR
%         JNormRBF       = JNormRBF+d*d;                       %J-th Norm
%         JNormRBF       = 0.5*JNormRBF/((HidVarRBF(j))^2);
%         HidOutRBF      = exp(-1*0.5*JNormRBF);
%         OutsRBF        = OutsRBF + OutWtsRBF(j)*HidOutRBF;
%     end
%     
%     OutputRBF  (i,1) = OutsRBF;
%     Empirical_1(i,1) = (24.0/rep+0.38+4.0/sqrt(rep))*...
%         (1.0+exp(-0.43/(map^4.67)));
%     
%     OutputRBF(i,1) - Empirical_1(i,1)/max3
% end
% Empirical_1 = Empirical_1/max3;

for i=1:length(Ix2)
    Input(1,1)=Ix2(i);
    map = Ix2(i)*max1;
    for j=1:length(Iy2)
        Input(1,2)=Iy2(j);
        rep = Iy2(j)*max2;
        
        OutsRBF=OBWtRBF;
        
        for k=1:nunitsRBF
            JNormRBF       = 0;
            d              = Input(1,1)-HidCtrRBF(k,1);          %Dis From CTR
            JNormRBF       = JNormRBF+d*d;
            d              = Input(1,2)-HidCtrRBF(k,2);          %Dis From CTR
            JNormRBF       = JNormRBF+d*d;                       %J-th Norm
            JNormRBF       = 0.5*JNormRBF/((HidVarRBF(k))^2);
            HidOutRBF      = exp(-1*0.5*JNormRBF);
            OutsRBF        = OutsRBF + OutWtsRBF(k)*HidOutRBF;
        end
        
        ORBF  (i,j) = OutsRBF;
        Empirical_2(j,i) = (24.0/rep+0.38+4.0/sqrt(rep))*...
            (1.0+exp(-0.43/(map^4.67)));
        
    end
end
Empirical_2 = Empirical_2/max3;

toc
a = 'Grid built'


%% Write to a file
dlmwrite('ORBF', ORBF, 'delimiter','\t','precision','%.9f')

fid = fopen('MA', 'w');
fprintf(fid, '%i = Number of Input Mach Numbers\n', length(Ix1));
fclose(fid);
dlmwrite('MA', Ix1, '-append', 'delimiter','\t', 'newline','pc');

fid = fopen('RE', 'w');
fprintf(fid, '%i = Number of Input Reynolds Numbers\n', length(Iy1));
fclose(fid);
dlmwrite('RE', Iy1, '-append', 'delimiter','\t', 'newline','pc');

dlmwrite('HidCtrRBF', HidCtrRBF', 'delimiter','\t','precision','%.9f')

dlmwrite('HidVarRBF', HidVarRBF', 'delimiter','\t','precision','%.9f')

dlmwrite('OutWtsRBF', OutWtsRBF', 'delimiter','\t','precision','%.9f')

fid = fopen('RBF_INPUT', 'w');
fprintf(fid, '%i = Number of Hidden Units\n', nunitsRBF);
fprintf(fid, '%f = OB Weight\n', OBWtRBF);
fprintf(fid, '%i = Number of Inputs (Re, Ma, ... etc.)\n', length(Inputs(1,:)));
fprintf(fid, '%f = Normalization factor for the first input\n', max1);
fprintf(fid, '%f = Normalization factor for the second input\n', max2);
fprintf(fid, '%f = Normalization factor for the drag', max3);
fclose(fid);

% ErRBF=sqrt((OutDesired-OutputRBF)'*(OutDesired-OutputRBF))/sqrt(OutDesired'*OutDesired);

DataPoints=N1-1;

% OUT=[nunitsRBF,DataPoints,ErRBF];
%Inputs=Inputs*180/pi;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                           TIME FOR NICE COLORFUL PICTURES
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ORBF = ORBF';
%%
[X2,Y2]=meshgrid(Ix2,Iy2);

imax = length(X2(:,1));
jmax = length(X2(1,:));

n=1;

% for i = 1:imax
%     for j = 1:jmax
%         ORBF(i,j)        = OutputRBF(n,1);
%         Empirical_2(i,j) = Empirical_1(n,1);
%         n=n+1;
%     end
% end

figure(1)

subplot(2,2,1)
surf(X2,Y2,Empirical_2,'EdgeColor','none')
xlabel('M/4')
ylabel('Re/10000')
zlabel('Drag(RBF)')
axis([min(Ix2),max(Ix2),min(Iy2),max(Iy2),0.3,1.4])
title(['Empirical Formula (Training Data)'])
colorbar

subplot(2,2,2)
contourf(X2,Y2,Empirical_2)
xlabel('M/4')
ylabel('Re/10000')
zlabel('Drag(RBF)')
title(['Empirical Formula (Training Data)'])
colorbar

subplot(2,2,3)
surf(X2,Y2,ORBF,'EdgeColor','none')
xlabel('M/4')
ylabel('Re/10000')
zlabel('Drag(RBF)')
axis([min(Ix2),max(Ix2),min(Iy2),max(Iy2),0.3,1.4])
title(['Drag Coefficient-RBF'])
colorbar

subplot(2,2,4)
contourf(X2,Y2,ORBF)
xlabel('M/4')
ylabel('Re/10000')
zlabel('Drag(RBF)')
title(['Drag Coefficient-RBF'])
colorbar

figure(2)

subplot(1,2,1)
surf(X2,Y2,ORBF,'EdgeColor','none')
xlabel('M/4')
ylabel('Re/10000')
zlabel('Drag(RBF)')
% axis([min(Ix2),max(Ix2),min(Iy2),max(Iy2),0.3,1.4])
caxis([0 1.7])
title(['NACA'])
colorbar

subplot(1,2,2)
contourf(X2,Y2,ORBF)
xlabel('M/4')
ylabel('Re/10000')
zlabel('Drag(RBF)')
title(['Drag Coefficient-RBF'])
colorbar