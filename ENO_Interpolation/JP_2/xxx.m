clear all;  clc; %close all;
particle = 55;

x0 = -10; x1 = 10;
N_grid = 20;
dx = (x1-x0) / (N_grid - 1);
x = x0 : dx : x1;
N0 = 1; N5 = N_grid; NV = 3;

%Q(:,1) = (x.^2 - 3)';
%Q(:,2) = (-x.^2 + 2.*x + 7)';
%Q(:,3) = (2.*x.^2 - 11.*x)';
Q(:,1) = (heaviside(x))';
Q(:,2) = (heaviside(x))';
Q(:,3) = (heaviside(x))';
% Q(3:15,:) = 1;

dXp = dx / 4;
Xp = x0 : dXp : x1;
Np = length(Xp);


Index = 2; Order = 5;

[Qfp, x_stencil] = Interpolate_Fluid_To_Particle(N0, N5, NV, Index,...
    Order, Xp, dx, x, Q);

figure(1)
plot(Qfp(1,:),'.')
% Qfp_Xp = [(Xp.^2 - 3); (-Xp.^2 + 2.*Xp + 7); (2.*Xp.^2 - 11.*Xp)];

figure(4)
plot(x,Q(:,1)), hold on
a(1:Np) = 0.5; plot(Xp, a, '.g'), hold on
plot(Xp(particle), 0.5, '.m'), hold on
b(1:Order+1) = 0.4; plot(x(x_stencil(:,particle)), b, '.-k'), hold off

% aux = zeros(1,Np);
% for i = 1 : Np
%     
%     aux(i) = norm( Qfp(1:3,i) - Qfp_Xp(:,i) );
%     
% end
% 
% error = mean(aux)