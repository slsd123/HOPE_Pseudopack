function [x_n,y_n,y_n_s] = Particle_Locate_Hostcell(N0, N5,...
    M0, M5, dy, Order, Xp, Yp, x0, x1, y0, y1)

x_n   = floor((Xp-x0)/(x1-x0)*(N5-N0)) + N0;
y_n   = floor((Yp-y0)/(y1-y0)*(M5-M0)) + M0;

y_half= 0.5*(y0 + y1);
y_n_s = floor((Yp-y_half)/dy) - floor(0.5*Order + 0.5 + 1e-12);
y_n_s = floor(y_n_s + (M5-M0)/2);