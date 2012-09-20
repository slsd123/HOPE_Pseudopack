function [Left,Bottom,Top] = ENO_Interpolation_Stencil (N0, N5, M0, M5,...
    Order, c1, c2, c2b)

Left   = zeros(N5,M5);
Bottom = zeros(N5,M5);
Top    = zeros(N5,M5);

% Determine Left most interpolating point with ENO approach
for j = M0:M5
    Left(N0,j) = N0; Left(N5-Order+1:N5,j) = N5-Order;
    for i = N0+1:N5-Order
        is = i;
        for m = 2:Order
            if (abs(c1(is-1,j,m)) < abs(c1(is,j,m)) && (is-1) >= N0)
                is = is - 1;
            end
        end
        Left(i,j) = is;
    end
end

% Determine Bottom most interpolating point with ENO approach
for i = N0:N5
    Bottom(i,M0) = M0; Bottom(i,M5-Order+1:M5) = M5-Order;
    for j = M0+1:M5-Order
        js = j;
        for m = 2:Order
            if (abs(c2(i,js-1,m)) < abs(c2(i,js,m)) && (js-1) >= M0)
                js = js - 1;
            end
        end
        Bottom(i,j) = js;
    end
end 

% Determine Top most interpolating point with ENO approach
for i = N0:N5
    Top(i,M5) = M5; Top(i,M0:M0+Order-2) = M0+Order-2;
    for j = M0+Order-1:M5-1
        js = j;
        for m = 2:Order-1
            if (abs(c2b(i,js+1,m)) < abs(c2b(i,js,m)) && (js+1)<=M5)
                js = js + 1;
            end
        end
        Top(i,j) = js;
    end
end