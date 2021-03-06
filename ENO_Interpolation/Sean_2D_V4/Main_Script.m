clear all; clc%; close all;

% Number of particles
Np = 500;
% Check the stencil for particle number:
particle = 155;

% Constants
NV    = 4;
Index = 2;
Order = 5;

% Initial Setup
Initial = 2; % 1=Diagonal, 2=Vertical

% Domain
x0       =  10;
x1       = -10;
N_grid_x =  100;

y0       =  10;
y1       = -10;
N_grid_y =  100;

% Creating the grid domain
dx       = (x1-x0)/(N_grid_x-1);
x        =  x0:dx:x1;
N0       =  1;
N5       =  N_grid_x;

dy       = (y1-y0)/(N_grid_y-1);
y        =  y0:dy:y1;
M0       =  1;
M5       =  N_grid_y;

[X,Y] = meshgrid(y0:dy:y1,y0:dy:y1);

% Putting the source onto the grid
offset_m = 50;
offset_p = 70;
Q = zeros(N_grid_x, N_grid_y, NV);

if Initial == 1
    for i = N_grid_x-offset_m:-1:1
        for j = 1:N_grid_x-i-offset_m
            Q(i,j,1) = 1;
            Q(i,j,2) = 1;
            Q(i,j,3) = 1;
            Q(i,j,4) = 1;
        end
    end
elseif Initial == 2
    Q(:,:,1) = (heaviside(-Y))';
    Q(:,:,2) = (heaviside(-Y))';
    Q(:,:,3) = (heaviside(-Y))';
    Q(:,:,4) = (heaviside(-Y))';
    Q(:,floor(N_grid_x/3):floor(2*N_grid_x/3),:) = 1;
end

% Particle initialization
x_0 = x0+5*dx;
x_1 = x1-5*dx;
y_0 = y0+5*dy;
y_1 = y1-5*dy;

dXp = (x_1-x_0)/(Np);
dYp = (y_1-y_0)/(Np);

Xp  = x_0+dXp/2:dXp:x_1-dXp/2;
Yp  = y_0+dYp/2:dYp:y_1-dYp/2;
% Yp(:) = 0;

[Qfp, x_stencil, y_stencil, c1, c2, c2b] = Interpolate_Fluid_To_Particle(N0, N5, M0, M5,...
    NV, Index, Order, Xp, Yp, dx, dy, x, y, Q);

% figure(1),plot(Q  (1,:,2),'.-b'), title('Q')
figure(2),plot(Qfp(2,:)  ,'.r'), title('Qfp')

figure(3)
contourf(X(1,:),Y(:,1),Q(:,:,2),1), hold on
plot(Xp,Yp,'.y'), hold on,  colorbar('EastOutside')
plot(x(x_stencil(:,particle)),y(y_stencil(particle,:)),'^-g'), hold on
plot(Xp(particle), Yp(particle), '.m'), hold on
plot(X, Y, '-k', Y, X, '-k'), hold off
xlabel('X'), ylabel('Y')

Q1 = Q(:,:,1);

c11 = c1(:,:,2); c22 = c2(:,:,3); c2b2 = c2b(:,:,4);