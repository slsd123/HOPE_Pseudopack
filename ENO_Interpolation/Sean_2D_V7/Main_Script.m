clear all; clc%; close all;

steps = 15000;
movie = 1;
theta = 90;
theta = theta/180*pi;
% Number of particles
Np = 60;
Part_init = 1;
% Check the stencil for particle number:
particle  = 27;
particle2 = 30;

% Constants
NV    = 4;
Index = 2;
Order = 5;

% Domain
x0       = -10;
x1       =  10;
N_grid_x =  50;

y0       = -10;
y1       =  10;
N_grid_y =  50;

% Creating the grid domain
dx       = (x1-x0)/(N_grid_x-1);
x        =  x0:dx:x1;
N0       =  1;
N5       =  N_grid_x;

dy       = (y1-y0)/(N_grid_y-1);
y        =  y0:dy:y1;
M0       =  1;
M5       =  N_grid_y;

[X,Y] = meshgrid(x0:dx:x1,y0:dy:y1);

% Putting the source onto the grid
Q                                  = zeros(N_grid_x, N_grid_y, NV);
Q(:,ceil(N_grid_y/2)+1:N_grid_y,:) = 1;

% Particle initialization
x_0 = x0+5*dx;
x_1 = x1-5*dx;
y_0 = y0+5*dy;
y_1 = y1-5*dy;

dXp = (x_1-x_0)/(Np);
dYp = (y_1-y_0)/(Np);

if Part_init == 1
    Xp  = (x_0+dXp/2:dXp:x_1-dXp/2);
    Yp  =  y_0+dYp/2:dYp:y_1-dYp/2;
elseif Part_init == 2
    Xp  = -(x_0+dXp/2:dXp:x_1-dXp/2);
    Yp  =   y_0+dYp/2:dYp:y_1-dYp/2;
elseif Part_init == 3
    Xp  = x_0+dXp/2:dXp:y_1-dXp/2;
    Yp  = y_0+dYp/2:dYp:y_1-dYp/2;
    Xp(:) = 0;
end

% Q_temp = Q;

for n=1:steps
    for i = N0:N5
        for j = M0:M5
            temp = [x(i) y(j)] * [cos(theta) -sin(theta);...
                                    sin(theta)  sin(theta)];
            temp_x = temp(1);
            temp_y = temp(2);
            
            if     temp_x > x1, temp_x = x1;
            elseif temp_x < x0, temp_x = x0; end
            if     temp_y > y1, temp_y = y1;
            elseif temp_y < y0, temp_y = y0; end
            
            [i0 j0] = Particle_Locate_HostCell(N0, N5, M0, M5,...
                temp_x, temp_y, x0, x1, y0, y1, Order);
            Q_temp(i0, j0, :) = Q(i, j, :);
        end
    end
%     Q = Q_temp;
    
    for i = 1:N5/10-1
        Q(N5/2+(i-1)*5+1:N5/2+i*5,M5/2+n:M5/2+n+i,:) = Q(N5/2+i*5,M5/2-1+n,1);
    end
    
if mod(n,movie) == 0
[Qfp, x_stencil, y_stencil, c1, c1r, c2, c2b, Top, Right] = Interpolate_Fluid_To_Particle...
    (N0, N5, M0, M5, NV, Index, Order, Xp, Yp, dx, dy, x, y, Q);

% figure(1),plot(Q  (1,:,2),'.-b'), title('Q')
figure(1),plot(Qfp(2,:)  ,'.r'), title('Qfp')

figure(4)
contourf(X(1,:), Y(:,1), Q(:,:,2)',2),  colorbar('EastOutside'), hold on
plot(Xp, Yp, '.y'), hold on
plot(x(x_stencil(:,particle)), y(y_stencil(particle,:)), '^-g'), hold on
plot(x(x_stencil(:,particle)'), y(y_stencil(particle,Order+1:-1:1)), '^-g'), hold on
plot(Xp(particle), Yp(particle), '.m'), hold on
plot(x(x_stencil(:,particle2)), y(y_stencil(particle2,:)), '^-g'), hold on
plot(x(x_stencil(:,particle2)), y(y_stencil(particle2,Order+1:-1:1)), '^-g'), hold on
plot(Xp(particle2), Yp(particle2), '.m'), hold on
plot(X, Y, '-k', Y, X, '-k')
ylabel('Y'), xlabel('X'),hold off
end
end
% 
% Q1 = Q(:,:,1);
% 
% c11  = c1 (1:N_grid_x-Order,:                     ,2);
% c22  = c2 (:               ,1:N_grid_y-Order      ,2);
% c2b2 = c2b(:               ,Order+1:N_grid_y-Order,2);