function [c1 c2 c2b] = Divided_Differences(N0, N5, M0, M5, x, y, Q, Index, Order)

c1 = zeros(N5-N0+1, Order);
c  = zeros(1, Order+1);

for j = M0:M5-Order
    for i = N0:N5-Order
        xa = x(i:i+Order);
        for n=1:Order+1
            c(n) = Q(i+n-1, j, Index);
        end
        for l = 1:Order
            for k = Order+1:-1:l+1
                c(k) = (c(k)-c(k-1))/(xa(k)-xa(k-l));
            end
            c1(i,l) = c(k);
        end
    end
end

c2 = zeros(M5-M0+1, Order);
for i = N0:N5-Order
    for j = M0:M5-Order
        ya = y(j:j+Order);
        for n=1:Order+1
            c(n) = Q(i, j+n-1, Index);
        end
        for l = 1:Order
            for k = Order+1:-1:l+1
                c(k) = (c(k)-c(k-1))/(ya(k)-ya(k-l));
            end
            c2(j,l) = c(k);
        end
    end
end

c2b = zeros(M5-M0+1, Order);
for i = N0:N5-Order
    for j = M0+Order:M5-Order
        ya = y(j:j+Order);
        for n=1:Order+1
            c(n) = Q(i, j-n+1, Index);
        end
        for l = 1:Order
            for k = Order+1:-1:l+1
                c(k) = (c(k)-c(k-1))/(ya(k)-ya(k-l));
            end
            c2b(j,l) = c(k);
        end
    end
end