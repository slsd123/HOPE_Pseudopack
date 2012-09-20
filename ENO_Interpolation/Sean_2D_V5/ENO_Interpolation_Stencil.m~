function [Left Bottom Top] = ENO_Interpolation_Stencil(N0, N5, M0, M5, Order, c1, c2, c2b)

Left                = zeros(N5-N0+1,M5-M0+1);
Left(N0,:           ) = 1;                             
Left(N5-Order+1:N5,:) = N5-Order;
for j = M0:M5
    for i = N0 + 1 : N5 - Order
        is = i;
        for m = 2 : Order
            if ((is-1) >= N0)
                if (abs(c1(is-1,j,m)) < abs(c1(is,j,m)))
                    is = is - 1;
                end
            end
        end
        Left(i,j) = is;
    end
end

Bottom                   = zeros(M5-M0+1, M5-M0+1);
Bottom(:, M0           ) = 1;
Bottom(:, M5-Order+1:M5) = M5-Order;
for j = N0:N5
    for i = M0+1:M5-Order
        is = i;
        for m = 2:Order
            if ((is-1) >= M0)
                if (abs(c2(j,is-1,m)) < abs(c2(j,is,m)))
                    is = is - 1;
                end
            end
        end
        Bottom(j,i) = is;
    end
end

Top                   = zeros(N5-N0+1, M5-M0+1);
Top(:, M0           ) = 1;
Top(:, M5-Order+1:M5) = M5-Order;
for j = N0:N5
    for i = M0:M5-Order
        is = i;
        for m = 2:Order
            if ((is+1) <= M5)
                if (abs(c2b(j,is+1,m)) < abs(c2b(j,is,m)))
                    is = is + 1;
                end
            end
        end
        Top(j,i) = is;
    end
end