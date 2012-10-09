function [x0, x1, y0, y1, cx, cy] = ENO_Interpolation_Setup(N0, N5, M0, M5, Order, x, y, dx, dy)

x0 = x(N0);
x1 = x(N5);

y0 = y(M0);
y1 = y(M5);

cx = zeros(1,Order+1);
cy = zeros(1,Order+1);

for n = 1:Order+1
    cx(n) = (n-1) * dx;
    cy(n) = (n-1) * dy;
end