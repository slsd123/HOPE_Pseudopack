function [f] = Polynomial (k, x, n, z)

if k==1
    f = (x-z(2))/(z(k)-z(2));
    for j = 3:n
        f = f*(x-z(j))/(z(k)-z(j));
    end
else
    f = (x-z(1))/(z(k)-z(1));
    for j = 2:k-1
        f = f*(x-z(j))/(z(k)-z(j));
    end
    for j = k+1:n
        f = f*(x-z(j))/(z(k)-z(j));
    end
end