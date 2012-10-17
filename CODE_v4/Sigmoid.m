function[ybar,ydash]=sigmoid(a)
ybar=tanh(a);
s=size(a);

for i=1:s(1)
    for j=1:s(2)
        ydash(i,j)=1/(cosh(a(i,j))*cosh(a(i,j)));
    end
end