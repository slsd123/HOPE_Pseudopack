function [x0, x1, cx] = ENO_Interpolation_Setup(N0, N5, Order, x, dx)
% Original version: function [x_Length, x0, cx] = ENO_Interpolation_Setup(N0, N5, Order, x, dx)
% JP version: [x0, cx] = ENO_Interpolation_Setup(N0, N5, Order, x, dx)


% x_Length = x(N5) - x(N0);
% Original verision: x_Length = x(N5) - x(N0);
% JP verision: %x_Length = x(N5) - x(N0);

x0 = x(N0);
x1 = x(N5);

cx = zeros( 1, Order + 1);

for n = 1 : Order + 1
   
    cx(n) = ( n - 1 ) * dx;
    
end