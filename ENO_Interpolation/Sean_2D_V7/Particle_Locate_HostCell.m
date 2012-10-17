function [x_n y_n] = Particle_Locate_HostCell(N0, N5, M0, M5, Xp, Yp, x0, x1, y0, y1, Order)

x_n   = floor((Xp-x0)/(x1-x0)*(N5-N0)) + N0;
y_n   = floor((Yp-y0)/(y1-y0)*(M5-M0)) + M0;

% dy = (y1-y0)/(M5-M0);
% y_half= 0.5*(y0+y1);
% y_n_s = floor((Yp-y_half)/dy)-floor(0.5*Order + 0.5 + eps);
% y_n_s = y_n_s+floor((M5-M0)/2)+Order;