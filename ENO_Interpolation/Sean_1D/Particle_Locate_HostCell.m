function [x_n] = Particle_Locate_HostCell(N0, N5, Xp, x0, x1)

x_n   = floor((Xp-x0)/(x1-x0)*(N5-N0)) + N0; 