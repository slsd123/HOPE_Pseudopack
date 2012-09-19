function [Qfp] = ENO_Interpolation(NV, Order, dx, dy, x, y, Q, dPdx,...
    Xp, Yp, i1, j1, j1t, Left, Bottom, Top, cx, cy)


i0 = Left(i1);
if Yp <= 0
    j0 = Top(j1t)-Order+1;
else
    j0 = Bottom(j1);%+Order-1;
end

xa = x(i1);
ya = y(j1);

dx1 = (Xp-xa)+(i1-i0)*dx;
dy1 = (Yp-ya)+(j1-j0)*dy;

hx = zeros(1,Order+1);
hy = zeros(1,Order+1);
for n = 1:Order+1
    hx(n) = Polynomial(n,dx1,Order+1,cx);
    hy(n) = Polynomial(n,dy1,Order+1,cy);
end

Qfp = zeros(NV+1,1);

for i = 1:NV
    Sum0 = 0;
    for n = 1:Order+1
        for m = 1:Order+1
            Sum0 = Sum0+Q(i0+n-1, j0+m-1, i)*hx(n)*hy(m);
%             Sum0 = Sum0+Q(i0+n-1, j0+n-1, i)*hx(n);%*hy(n);
        end
    end
    Qfp(i,1) = Sum0;
end
Sum0 = 0;
for n = 1:Order+1
    Sum0 = Sum0+dPdx(i0+n-1)*hx(n)*hy(n);
end
Qfp(NV+1,1) = Sum0;