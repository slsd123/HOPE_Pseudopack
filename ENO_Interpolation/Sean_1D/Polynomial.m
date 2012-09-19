function [f] = Polynomial(k, x, n, z)

% Program description: It computes the value of the k-th cardinal Lagrange
% ===================  polynomial of degree (n - 1) evaluated on x, for
%                      the grid points {z(1),z(2),...,z(n)}. Namely,
%                      f = L_{k}^{n-1}(x), for k = 1,2,...,n.


% Old version
% ===========
% 
switch k
    
   case 1
        
       f = ( x - z(2) ) / ( z(k) - z(2) );
       for j = 3 : n
          f = f * ( x - z(j) ) / ( z(k) - z(j) );
       end
        
   otherwise
        
       f = ( x - z(1) ) / ( z(k) - z(1) );
       for j = 2 : k-1
          f = f * ( x - z(j) ) / ( z(k) - z(j) );
       end

       for j = k + 1 : n
          f = f * ( x - z(j) ) / ( z(k) - z(j) );
       end
        
end


% Sean's version
% ==============

% if ( k == 1 )
%     
%     f = (x - z(2))/(z(k) - z(2));
%     
%     for j = 3 : n
%         
%         f = f*(x - z(j))/(z(k) - z(j));
%         
%     end
%     
% else
%     
%     f = (x - z(1))/(z(k) - z(1));
%     
%     for j = 2 : k - 1
%         
%         f = f*(x - z(j))/(z(k) - z(j));
%         
%     end
%     
%     for j = k + 1 : n
%         
%         f = f*(x - z(j))/(z(k) - z(j));
%         
%     end
%     
% end