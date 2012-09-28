function [Qfp, x_stencil, y_stencil, c1, c2, c2b, Top] = Interpolate_Fluid_To_Particle(N0, N5, M0, M5, NV, Index,...
    Order, Xp, Yp, dx, dy, x, y, Q)
[x0, x1, y0, y1, cx, cy] = ENO_Interpolation_Setup(N0, N5, M0, M5, Order,...
    x, y, dx, dy);

[c1 c2 c2b]    = Divided_Differences(N0, N5, M0, M5, x, y, Q, Index, Order);
[Left Bottom Top]  = ENO_Interpolation_Stencil(N0, N5, M0, M5, Order, c1, c2, c2b);

Np   = length(Xp);
Qfp  = zeros(NV+1, Np);
dPdx = zeros(N0, N5-N0+1);
for np = 1 : Np
    [x_n y_n y_n_s] = Particle_Locate_HostCell(N0, N5, M0, M5, Xp(np), Yp(np),...
        x0, x1, y0, y1, Order);
    
% Algorithm in WENO Code must use y_n_s because it balances including the ghost points.
% Here, y_n must be used because there aren't any ghost points.    
    [Qfp(:,np), x_stencil(:,np), y_stencil(np,:)] = ENO_Interpolation(NV, Order, dx, dy, x, y, Q, dPdx,...
        Xp(np), Yp(np), x_n, y_n, Left, Bottom, Top, cx, cy);
end