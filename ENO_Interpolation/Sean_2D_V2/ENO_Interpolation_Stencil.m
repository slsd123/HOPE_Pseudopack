function [Left] = ENO_Interpolation_Stencil(N0, N5, Order, c1)

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