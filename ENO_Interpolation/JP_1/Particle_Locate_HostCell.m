function [x_n] = Particle_Locate_HostCell(N0, N5, Xp_i, x0, x1)

x_n   = fix( ( Xp_i - x0 ) / ( x1 - x0 ) * ( N5 - N0 ) ) + N0; 