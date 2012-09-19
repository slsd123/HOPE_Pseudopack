function [c1] = Divided_Differences(N0, N5, x, Q, Index, Order)

c1 = zeros(N5-N0+1, Order);
c  = zeros(1, Order+1);

 for i = N0:N5-Order 
    xa = x(i:i+Order);
    for n=1:Order+1
        c(n) = Q(i+n-1, Index);
    end
     for l = 1:Order
        for k = Order+1:-1:l+1
            c(k) = (c(k)-c(k-1))/(xa(k)-xa(k-l));
        end
        c1(i,l) = c(k);
     end
end