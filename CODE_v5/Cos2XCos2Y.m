% This programs tests RBF for a given function



%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                          GENERATE THE I/O PATTERN
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

n1=1;
p1=1;
for i=0:45:360
    
    AngleX=i*pi/180;
    Ix1(p1)=i;
    q1=1;
    for j=0:45:360
        
        AngleY=j*pi/180;
        Inputs(n1,1)=AngleX;
        Iy1(q1)=j;
        Inputs(n1,2)=AngleY;
        OutDesired(n1,1)=cos(2*AngleX)*cos(2*AngleY);
        q1=q1+1;
        n1=n1+1;
    end
    p1=p1+1;
end
INP=Inputs*180/pi;
OUTP=OutDesired;
N1=n1;


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                        DESIGN OF THE RADIAL BASIS FUNCTION NETWORK
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

nunitsRBF=70; % No.of Units in the Hidden Layer
[HidCtrRBF,HidVarRBF,OBWtRBF,OutWtsRBF,ClusterRBF]=UnspuerRBF(nunitsRBF,0.02,Inputs,OutDesired,3200,0.01);



%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                                TESTING THE RBF NETWORK
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

n=1;
p=1;
for i=0:10:360
    
    AngleX=i*pi/180;
    Ix(p)=i;
    q=1;
    for j=0:10:360
        AngleY=j*pi/180;
        Inputs(n,1)=AngleX;
        Iy(q)=j;
        Inputs(n,2)=AngleY;
        OutDesired(n,1)=cos(2*AngleX)*cos(2*AngleY);
        q=q+1;
        n=n+1;
    end
    p=p+1;
end


for i=1:n-1

    Input(1,1)=Inputs(i,1);
    Input(1,2)=Inputs(i,2);
    
    
    for j=1:nunitsRBF
        
        d(1,1) = Input(1,1)-HidCtrRBF(j,1);%Dis From CTR
        d(2,1) = Input(1,2)-HidCtrRBF(j,2);%Dis From CTR
        CoVarRBF = HidVarRBF(j);%jth Covar            
        JNormRBF(j)= d'*d; % J-th Norm
        JNormRBF(j)=0.5*JNormRBF(j)/((HidVarRBF(j))^2);
        HidOutRBF(1,j)=exp(-1*0.5*JNormRBF(j));  
    end
    
    OutsRBF=OBWtRBF+OutWtsRBF*HidOutRBF'; %Output Calculated
    OutsRBF=OutsRBF'; %For consistency, column vector
    
    OutputRBF(i,1)=OutsRBF;
    
end
    

ErRBF=sqrt((OutDesired-OutputRBF)'*(OutDesired-OutputRBF))/sqrt(OutDesired'*OutDesired);

DataPoints=N1-1;

OUT=[nunitsRBF,DataPoints,ErRBF]
Inputs=Inputs*180/pi;
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                            TIME FOR NICE COLORFUL PICTURES
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

[X1,Y1]=meshgrid(Ix1,Iy1);

n1=1;
lenx1=size(Ix1);
leny1=size(Iy1);
for i=1:lenx1(2)
    for j=1:leny1(2)
        OD(i,j)=OUTP(n1,1);
        n1=n1+1;
    end
end


[X,Y]=meshgrid(Ix,Iy);

n=1;
lenx=size(Ix);
leny=size(Iy);
for i=1:lenx(2)
    for j=1:leny(2)
        ODesired(i,j)=OutDesired(n,1);
        ORBF(i,j)=OutputRBF(n,1);
        n=n+1;
    end
end


figure(1)

subplot(3,2,1)
surf(X1,Y1,OD)
xlabel('x(deg)')
ylabel('y(deg)')
zlabel('Z(Analytical)')
axis([min(Ix),max(Ix),min(Iy),max(Iy),-1.2,1.2])
title(['Data For Training'])
colorbar

subplot(3,2,2)
contourf(X1,Y1,OD)
xlabel('x(deg)')
ylabel('y(deg)')
zlabel('Desired')
title(['Data For Training'])
colorbar

subplot(3,2,5)
surf(X,Y,ODesired)
xlabel('x(deg)')
ylabel('y(deg)')
zlabel('Z(Analytical)')
axis([min(Ix),max(Ix),min(Iy),max(Iy),-1.2,1.2])
title(['Z=cos(2x)cos(2y)'])
colorbar

subplot(3,2,3)
surf(X,Y,ORBF)
xlabel('x(deg)')
ylabel('y(deg)')
zlabel('Z(RBF)')
axis([min(Ix),max(Ix),min(Iy),max(Iy),-1.2,1.2])
title(['Z=cos(2x)cos(2y)'])
colorbar

subplot(3,2,6)
 contourf(X,Y,ODesired)
 xlabel('x(deg)')
 ylabel('y(deg)')
 zlabel('Desired')
 title(['cos(2x)cos(2y)-Exact'])
 colorbar
 
 subplot(3,2,4)
 contourf(X,Y,ORBF)
 xlabel('x(deg)')
 ylabel('y(deg)')
 zlabel('Z(RBF)')
 title(['cos(2x)cos(2y)-RBF'])
 colorbar
 
