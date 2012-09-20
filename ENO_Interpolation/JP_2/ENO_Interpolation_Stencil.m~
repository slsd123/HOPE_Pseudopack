function [Left] = ENO_Interpolation_Stencil(N0, N5, Order, c1)

% Program description: It determines the Left most interpolating point
% ===================  with the ENO scheme.

Left = zeros(1, N5 - N0 + 1);
% -----------------------------------------
% JP version: Add the following            
Left( N0 ) = 1;                             
Left( N5 - Order + 1 : N5 ) = N5 - Order; 
% ----------------------------------------- 

for i = N0 + 1 : N5 - Order 
% Original version: for i = N0 + Order + 1 : N5
% JP version:       for i = N0 + 1 : N5 - Order

    is = i;
	      
    for m = 2 : Order 
         
         if ( abs( c1(is-1,m) ) < abs( c1(is,m) ) && is - 1 >= N0  )
         % Original version: if ( abs( c1(is-1,m) ) < abs( c1(is,m) ) )
         % JP version: if ( abs( c1(is-1,m) ) < abs( c1(is,m) ) && is - 1 >= N0  )             
            
            is = is - 1;
		
         end
        
    end
	  
    Left(i) = is;

end