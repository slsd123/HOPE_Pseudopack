function [Left Bottom Top] = ENO_Interpolation_Stencil(N0, N5, M0, M5, Order, c1, c2, c2b)

Left                = zeros(1, N5-N0+1);
Left(N0           ) = 1;                             
Left(N5-Order+1:N5) = N5-Order; 

for i = N0 + 1 : N5 - Order 
    is = i;
    for m = 2 : Order 
         if (abs(c1(is-1,m)) < abs(c1(is,m)) && (is-1) >= N0)            
            is = is - 1;
         end
    end
    Left(i) = is;
end

Bottom                = zeros(1, M5-M0+1);
Bottom(M0           ) = 1;                             
Bottom(M5-Order+1:M5) = M5-Order; 

for i = M0+1:M5-Order 
    is = i;
    for m = 2:Order 
         if (abs(c2(is-1,m)) < abs(c2(is,m)) && (is-1) >= M0)            
            is = is - 1;
         end
    end
    Bottom(i) = is;
end

Top                = zeros(1, M5-M0+1);
Top(M0           ) = 1;                             
Top(M5-Order+1:M5) = M5-Order;  

for i = M0:M5-1
    is = i;
    for m = 2:Order 
         if (abs(c2b(is+1,m)) < abs(c2b(is,m)) && (is+1) <= M5)            
            is = is + 1;
         end
    end
    Top(i) = is;
end