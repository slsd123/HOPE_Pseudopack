clear all; clc%; close all;

% Number of particles
Np = 500;
% Check the stencil for particle number:
particle  = 288;
particle2 = 289;

% Constants
NV    = 4;
Index = 2;
Order = 5;
AVG   = 0;
for AVG = 0:5
% Initial Setup
Initial   = 2; % Fluid: 1=diagonal, 2=diagonal (opp), 3=horizontal
Part_init = 2; % Part: 1=diagonal (perpendic), 2=diagonal(along), 3=vertical

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
offset_m = 0;
offset_p = 0;
Q = zeros(N_grid_x, N_grid_y, NV);

if Initial == 1
    for i = N_grid_x-offset_m:-1:1
        for j = 1:N_grid_x-i-offset_m
            Q(i,j,:) = 1;
        end
    end
elseif Initial == 2
    for i = 1:N_grid_x-offset_m
        for j = 1:N_grid_x-i-offset_m
            Q(i,j,:) = 1;
        end
    end
elseif Initial == 3
    Q = zeros(N_grid_x, N_grid_y, NV);
%     Q(:,ceil(N_grid_y/3):N_grid_y,:) = 1;
    Q(:,ceil(N_grid_y/2)+1:N_grid_y,:) = 1;
elseif Initial == 4
    for i = 1:N_grid_y
        Q(1:N_grid_x,i, 1:NV) = i;
    end
end

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
    Yp  =  (y_0+dYp/2:dYp:y_1-dYp/2);
elseif Part_init == 3
    Xp  = x_0+dXp/2:dXp:y_1-dXp/2;
    Yp  = y_0+dYp/2:dYp:y_1-dYp/2;
    Xp(:) = 0;
end

for n = 1:AVG
    Q_temp = Q;
    for i = 2:N_grid_x-1
        for j = 2:N_grid_y-1
            Q(i,j,:) = (Q_temp(i+1,j) + Q_temp(i,j+1) + Q_temp(i+1,j+1) +...
                        Q_temp(i-1,j) + Q_temp(i,j-1) + Q_temp(i-1,j-1) +...
                        Q_temp(i-1,j+1) + Q_temp(i+1,j-1))/8;
        end
    end
end

[Qfp, x_stencil, y_stencil, c1, c1r, c2, c2b, Top, Right] = Interpolate_Fluid_To_Particle...
    (N0, N5, M0, M5, NV, Index, Order, Xp, Yp, dx, dy, x, y, Q);

% figure(1),plot(Q  (1,:,2),'.-b'), title('Q')
figure(1),plot(Qfp(2,:)  ,'.r'), title('Qfp')
axis([0 500 0 1])
q=['Averaged over ' num2str(AVG)];
title(q)

figure(4)
if Initial == 4
    contourf(X(1,:), Y(:,1), Q(:,:,2)'),  colorbar('EastOutside'), hold on
elseif AVG > 0
    contourf(X(1,:), Y(:,1), Q(:,:,2)'),  colorbar('EastOutside'), hold on
else
    contourf(X(1,:), Y(:,1), Q(:,:,2)',2),  colorbar('EastOutside'), hold on
end
plot(Xp, Yp, '.y'), hold on
plot(x(x_stencil(:,particle)), y(y_stencil(particle,:)), '^-g'), hold on
plot(x(x_stencil(:,particle)'), y(y_stencil(particle,Order   :-1:1)), '^-g'), hold on
plot(Xp(particle), Yp(particle), '.m'), hold on
plot(x(x_stencil(:,particle2)), y(y_stencil(particle2,:)), '^-g'), hold on
plot(x(x_stencil(:,particle2)), y(y_stencil(particle2,Order   :-1:1)), '^-g'), hold on
plot(Xp(particle2), Yp(particle2), '.m'), hold on
plot(X, Y, '-k', Y, X, '-k'), hold on
ylabel('Y'), xlabel('X'), hold off

figure(2)
subplot(1,6,AVG+1), plot(Qfp(2,:)  ,'.r'), title('Qfp')
axis([0 500 0 1])
q=['Avg Over ' num2str(AVG) ' Cells'];
title(q), ylabel('Qfp'), xlabel('Particle Number')

end

Q1 = Q(:,:,1);

c11  = c1 (1:N_grid_x-Order,:                     ,2);
c22  = c2 (:               ,1:N_grid_y-Order      ,2);
c2b2 = c2b(:               ,Order+1:N_grid_y-Order,2);