clear all; close all; clc

%Set up the Problem Parameters
P.NV  = 4;              % 4 Equations in 2D
Index = 2;              % Which parameter to check smoothness
Order = 3;              % ENO Interpolation Order

%Set up the x-grid parameters
P.x0     = -10;
P.x1     =  10;
N_grid_x =  20;
dx       = (P.x1-P.x0)/(N_grid_x-1);
N0       =  1;
N5       =  N_grid_x;
%Set up the y-grid parameters
P.y0     = -10;
P.y1     =  10;
N_grid_y =  20;
dy       = (P.y1-P.y0)/(N_grid_y-1);
M0       =  1;
M5       =  N_grid_y;

[x,y]=meshgrid(P.x0:dx:P.x1,P.y0:dy:P.y1);

%Set up the Flow parameters
Q        = zeros(N5,M5,P.NV);
Q(:,:,1) = [heaviside(x)]';
Q(:,:,2) = [heaviside(x)]';
Q(:,:,3) = [heaviside(x)]';
Q(:,:,4) = [heaviside(x)]';

%Set up the particle parameters
P.Np_x = N_grid_x;
dXp  = (P.x1-P.x0)/(P.Np_x-1)/2;
P.Np_y = N_grid_y;
dYp  = (P.y1-P.y0)/(P.Np_y-1)/2;

%Total number of particles
P.Np = P.Np_y*P.Np_x;
np = 1;

%Allocate the (x,y) arrays for the particle position
P.Xp(1:P.Np) = (P.x1-P.x0)/4+P.x0;
P.Yp(1:P.Np) = (P.y1-P.y0)/4+P.y0;

%Set up the particle cloud inside of the domain
for i=1:P.Np_x
    for j=1:P.Np_y
        P.Xp(np) = (P.x1-P.x0)/4+P.x0+dXp*(i-1);
        P.Yp(np) = (P.y1-P.y0)/4+P.y0+dYp*(j-1);
        np=np+1;
    end
end

[Qfp] = Interpolate_Fluid_To_Particle(N0, N5, M0, M5, dx, dy, x, y,...
    Q, P, Index, Order);

figure(1),  subplot(1,2,1),plot(Q(:,10,2)), title('Q')
            subplot(1,2,2),plot(Qfp(2,: )), title('Qfp')