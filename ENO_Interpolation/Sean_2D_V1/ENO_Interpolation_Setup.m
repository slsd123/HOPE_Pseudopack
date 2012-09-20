function [cx,cy] = ENO_Interpolation_Setup (Order, dx, dy)

cx = zeros(1,Order+1);
cy = zeros(1,Order+1);

for n = 1:Order+1
    cx(n) = (n-1)*dx;
    cy(n) = (n-1)*dy;
end