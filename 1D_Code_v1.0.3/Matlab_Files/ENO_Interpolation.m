function [Qfp] = ENO_Interpolation(NV, Order, dx, x, Q, dPdx, Xp_i, i1, Left, cx)

i0 = Left(i1);

xa = x(i1); 

dx1 = ( Xp_i - xa ) + ( i1 - i0 ) * dx;

hx = zeros(1, Order + 1);
for n = 1 : Order + 1
    
    hx(n) = Polynomial(n, dx1, Order + 1, cx);
     
end

Qfp = zeros(NV + 1,1);
for i = 1 : NV

    Sum0 = 0;
    
    for n = 1 : Order + 1
       
        Sum0 = Sum0 + Q( i0 + n - 1, i ) * hx(n);
                
    end
    
    Qfp(i,1) = Sum0;
    
end
 
Sum0 = 0;

for n = 1 : Order + 1
        
    Sum0 = Sum0 + dPdx( i0 + n - 1 ) * hx(n);
        
end

Qfp(NV + 1,1) = Sum0;