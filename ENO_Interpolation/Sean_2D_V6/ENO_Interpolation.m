function [Qfp, x_stencil, y_stencil] = ENO_Interpolation(NV, Order, dx, dy, x, y, Q, dPdx,...
    Xp, Yp, i1, j1, Left, Right, Bottom, Top, cx, cy)

if Xp < 0
    i0 = Right(i1,j1)-Order+1;
else
    i0 = Left(i1,j1);
end

if Yp <= 0
    j0 = Top (i1,j1)-Order+1;
else
    j0 = Bottom(i1,j1);
end

xa = x(i1);
ya = y(j1);

dx1 = (Xp-xa)+(i1-i0)*dx;
dy1 = (Yp-ya)+(j1-j0)*dy;

hx = zeros(1,Order+1);
hy = zeros(1,Order+1);
for n = 1:Order+1
    hx(n) = Polynomial(n, dx1, Order+1, cx);
    hy(n) = Polynomial(n, dy1, Order+1, cy);
end

Qfp = zeros(NV+1,1);

for i = 1:NV
    Sum0 = 0;
    for n = 1:Order+1
        for m = 1:Order+1
            Sum0 = Sum0+Q(i0+n-1, j0+m-1, i)*hy(m)*hx(n);
            x_stencil(n, m) = i0+n-1;
            y_stencil(n, m) = j0+m-1;
        end
    end
    Qfp(i,1) = Sum0;
end

x_stencil = x_stencil(:,1);
y_stencil = y_stencil(1,:);

Sum0 = 0;
for n = 1:Order+1
    Sum0 = Sum0+dPdx(i0+n-1)*hx(n)*hy(n);
end
Qfp(NV+1,1) = Sum0;