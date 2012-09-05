function [c1] = Divided_Differences(N0, N5, x, Q, Index, Order)

% Program description: It computes the divided differences for the
% ===================  interpolation data {x(i),Q(i,Index)}. The
%                      output is a (N5 - N0 + 1 x Order) matrix
%                      which has in the entry (i,j), the j-th order
%                      divided difference corresponding to Q(x(i),Index). 

c1 = zeros( N5 - N0 + 1, Order );
c = zeros( 1, Order + 1  );

 for i = N0 : N5 - Order 
 % Original version: for i = N0 + Order + 1 : N5 - Order - 1
 % JP version:       for i = N0 : N5 - Order
 
    xa = x( i : i + Order );
    
    for n = 1 : Order + 1 
        
        c(n) = Q( i + n - 1, Index );
        
    end
    
     for l = 1 : Order
                 
        for k = Order + 1 : -1 : l + 1
                       
            c(k) = ( c(k) - c(k-1) ) / ( xa(k) - xa(k-l) ) ;
            
        end
        
        c1(i,l) = c(k);

    end
    
end