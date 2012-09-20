function [Qfp] = ENO_Interpolation(NV, Order, dx, dy,...
    x, y, Q, dPdx, dPdy, Xp, Yp, i1, j1, Left, Bottom, Top, cx, cy)

Qfp = zeros(NV+2,1);
hx  = zeros(1,Order+1);
hy  = zeros(1,Order+1);

% Look up the interpolation stencil
i0 =    Left(i1,j1);

% if (Yp > 0)
    j0  = Bottom(i1,j1);
% elseif (Yp <= 0)
%     j0  = Top(i1,j1);%-Order+1;
% end

xa = x(i1,j1); ya = y(i1,j1);

dx1 = (Xp-xa)+(i1-i0)*dx;
dy1 = (Yp-ya)+(j1-j0)*dy;

% Determine the Lagrange interpolant
for n = 1:Order
    [hx(n)] = Polynomial(n, dx1, Order, cx);
    [hy(n)] = Polynomial(n, dy1, Order, cy);
end
for n = 1:Order
    for m = 1:Order
        h(n,m) = hx(n)*hy(m);
    end
end

% Lagrange interpolation
for i = 1:NV
    Sum0 = 0;
    for n = 1:Order
        for m = 1:Order
            Sum0 = Sum0+Q(i0+n-1,j0+m-1,i)*h(n,m);
        end
    end
    Qfp(i,1) = Sum0;
end

Sum0 = 0;
Sum1 = 0;
for n = 1:Order
    for m = 1:Order
        Sum0 = Sum0 + dPdx*h(n,m);
        Sum1 = Sum1 + dPdy*h(n,m);
    end
end
Qfp(NV+1,1) = Sum0;
Qfp(NV+2,1) = Sum1;
