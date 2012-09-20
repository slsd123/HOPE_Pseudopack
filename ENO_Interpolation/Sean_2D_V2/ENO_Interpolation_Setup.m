function [x0, x1, cx] = ENO_Interpolation_Setup(N0, N5, Order, x, dx)

x0 = x(N0);
x1 = x(N5);

cx = zeros(1,Order+1);

for n = 1:Order+1
   
    cx(n) = (n-1) * dx;
    
end