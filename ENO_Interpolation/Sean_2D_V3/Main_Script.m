clear all; clc;% close all;

x0       = -10;
x1       =  10;
N_grid_x =  20;
dx       = (x1-x0)/(N_grid_x-1);
x        =  x0:dx:x1;
N0       =  1;
N5       =  N_grid_x;

y0       = -10;
y1       =  10;
N_grid_y =  20;
dy       = (y1-y0)/(N_grid_y-1);
y        =  y0:dy:y1;
M0       =  1;
M5       =  N_grid_y;

NV = 4;

[X,Y] = meshgrid(y0:dy:y1,y0:dy:y1);

Q = zeros(N_grid_x, N_grid_y, NV);
Q(:,:,1) = (heaviside(Y))';
Q(:,:,2) = (heaviside(Y))';
Q(:,:,3) = (heaviside(Y))';
Q(:,:,4) = (heaviside(Y))';

Np = 10000;
x_0 = x0+3*dx;
x_1 = x1-3*dx;

dXp = (x_1-x_0)/(Np);
Xp  = x_0+dXp/2:dXp:x_1-dXp/2;
Yp  = x_0+dXp/2:dXp:x_1-dXp/2;

Index = 2; Order = 3;

figure(3)
imagesc(X(1,:),Y(:,1),Q(:,:,2)), hold on
plot(Xp,Yp,'.g'), hold off
% grid on, grid minor

[Qfp] = Interpolate_Fluid_To_Particle(N0, N5, M0, M5, NV, Index, Order,...
    Xp, Yp, dx, dy, x, y, Q);

figure(1),plot(Q  (1,:,2),'.-b'), title('Q')
figure(2),plot(Qfp(2,:)  ,'.-r'), title('Qfp')