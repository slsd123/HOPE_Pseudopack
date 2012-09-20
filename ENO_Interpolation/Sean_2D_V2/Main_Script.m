clear all, close all; clc

x0     = -10;
x1     =  10;
N_grid =  20;
dx     = (x1-x0)/(N_grid-1);
x      =  x0:dx:x1;
N0     =  1;
N5     =  N_grid;
NV     =  3;

%Set up the Flow parameters
% Q        = zeros(N5,M5,P.NV);
Q(:,:,1) = (heaviside(x))';
Q(:,:,2) = (heaviside(x))';
Q(:,:,3) = (heaviside(x))';
Q(:,:,4) = (heaviside(x))';

Np = 7;

dXp = (x1-x0)/(Np);
Xp  = x0+dXp/2:dXp:x1-dXp/2;
Yp  = x0+dXp/2:dXp:x1-dXp/2;

Index = 2; Order = 3;

[Qfp] = Interpolate_Fluid_To_Particle(N0, N5, NV, Index, Order, Xp, dx, x, Q);

figure(1),plot(Q(:,1,2),'.-b'), title('Q')
figure(2),plot(Qfp(2,:),'.-r'), title('Qfp')