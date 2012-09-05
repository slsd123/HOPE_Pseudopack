function [Qfp] = Interpolate_Fluid_To_Particle(N0, N5, NV, Index, Order, Xp, dx, x, Q)
% Original version: function [Qfp] = Interpolate_Fluid_To_Particle(N0, N5, NV, Index, Order, Xp, dx, x, Q, x1)
% JP version: function [Qfp] = Interpolate_Fluid_To_Particle(N0, N5, NV, Index, Order, Xp, dx, x, Q)

[x0, x1, cx] = ENO_Interpolation_Setup(N0, N5, Order, x, dx);
% Original version: [x_Length, x0, cx] = ENO_Interpolation_Setup(N0, N5, Order, x, dx);
% JP verision: [x0, x1, cx] = ENO_Interpolation_Setup(N0, N5, Order, x, dx);

[c1] = Divided_Differences(N0, N5, x, Q, Index, Order);

[Left] = ENO_Interpolation_Stencil(N0, N5, Order, c1);

Np = length(Xp);
Qfp = zeros(NV + 1, Np);
dPdx = zeros(N0, N5 - N0 + 1);
for np = 1 : Np
   
    [x_n] = Particle_Locate_HostCell(N0, N5, Xp(np), x0, x1);
    
    [Qfp(:,np)] = ENO_Interpolation(NV, Order, dx, x, Q, dPdx, Xp(np), x_n, Left, cx);
 
end
