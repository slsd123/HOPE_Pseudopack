% This program plots the results from the RBF data
function Plotting(test_pts, map_max, rep_max, map_min, rep_min, cd_max, HidCtrRBF,...
    HidVarRBF, OBWtRBF, OutWtsRBF, nunitsRBF)

Ix2 = map_min:(map_max-map_min)/(test_pts-1):map_max;
Ix2  = Ix2/map_max;
Iy2 = rep_min:(rep_max-rep_min)/(test_pts-1):rep_max;
Iy2  = Iy2/rep_max;

for i = 1:length(Iy2)
    Inputs2(length(Ix2)*(i-1)+1:length(Ix2)*i,2) = Iy2(i);
end
for i = 1:length(Iy2)
    Inputs2(length(Ix2)*(i-1)+1:length(Ix2)*i,1) = Ix2;
end

a = 'Building grid'
tic
for i=1:length(Ix2)
    Input(1,1)=Ix2(i);
    map = Ix2(i)*map_max;
    for j=1:length(Iy2)
        Input(1,2)=Iy2(j);
        rep = Iy2(j)*rep_max;
        
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
        Empirical(j,i) = (24.0/rep+0.38+4.0/sqrt(rep))*...
            (1.0+exp(-0.43/(map^4.67)));
        
    end
end
Empirical = Empirical/cd_max;

toc
a = 'Grid built'

ORBF = ORBF';

[X2,Y2]=meshgrid(Ix2,Iy2);

imax = length(X2(:,1));
jmax = length(X2(1,:));

n=1;

figure(1)

subplot(2,2,1)
surf(X2,Y2,Empirical,'EdgeColor','none')
xlabel('M/4')
ylabel('Re/10000')
zlabel('Drag(RBF)')
% axis([min(Ix2),max(Ix2),min(Iy2),max(Iy2),0.3,1.4])
title(['Empirical Formula (Training Data)'])
colorbar

subplot(2,2,2)
contourf(X2,Y2,Empirical)
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
% axis([min(Ix2),max(Ix2),min(Iy2),max(Iy2),0.3,1.4])
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