% This programs tests and compares different neural networks for training
% the patter Y=Cos(x)

%TYPES OF NETWORK COMPARED
%1. Three Layer Perceptron
%2. Radial-Basis Function Network

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                          GENERATE THE I/O PATTERN
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

n=1;
p=1;
for i=-1:0.4:1
    
    Ix(p)=i;
    q=1;
    for j=-1:0.4:1
        Inputs(n,1)=i;
        Iy(q)=j;
        Inputs(n,2)=j;
        OutDesired(n,1)=legendre(0,i)*j;
        q=q+1;
        n=n+1;
    end
    p=p+1;
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                        DESIGN OF THE TWO LAYER PERCEPTRON NETWORK
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
nunitsTLP1=2; % No.of Units in the First Hidden Layer
nunitsTLP2=2;
[HWts1TLP,HWts2TLP,OWtsTLP,HBWT1TLP,HBWT2TLP,OBWTLP,ErrorTLP,NitTLP]=ThreeLP(nunitsTLP1,nunitsTLP2,0.02,Inputs,OutDesired,3200,0.01);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                        DESIGN OF THE RADIAL BASIS FUNCTION NETWORK
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%nunitsRBF=12; % No.of Units in the Hidden Layer
%[HidCtrRBF,HidVarRBF,OBWtRBF,OutWtsRBF,ClusterRBF]=UnSupRBF(nunitsRBF,0.02,Inputs,OutDesired,3200,0.01);


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                               TESTING THE TLP NETWORK
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

for i=1:(n-1)
    A=[Inputs(i,1),Inputs(i,2)];
    OutputTLP(i,1)=Sigmoid(OBWTLP+(OWtsTLP*Sigmoid(HBWT2TLP+HWts2TLP*Sigmoid(HBWT1TLP+HWts1TLP*A'))));
end

ErTLP=sqrt((OutDesired-OutputTLP)'*(OutDesired-OutputTLP))/sqrt(OutDesired'*OutDesired);

% %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% %                                TESTING THE RBF NETWORK
% %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% 
% for i=1:n-1
% 
%     Input(1,1)=Inputs(i,1);
%     Input(1,2)=Inputs(i,2);
%     
%     
%     for j=1:nunitsRBF
%         
%         d(1,1) = Input(1,1)-HidCtrRBF(j,1);%Dis From CTR
%         d(2,1) = Input(1,2)-HidCtrRBF(j,2);%Dis From CTR
%         CoVarRBF = HidVarRBF(j);%jth Covar            
%         JNormRBF(j)= d'*d; % J-th Norm
%         JNormRBF(j)=0.5*JNormRBF(j)/((HidVarRBF(j))^2);
%         HidOutRBF(1,j)=exp(-1*0.5*JNormRBF(j));  
%     end
%     
%     OutsRBF=OBWtRBF+OutWtsRBF*HidOutRBF'; %Output Calculated
%     OutsRBF=OutsRBF'; %For consistency, column vector
%     
%     OutputRBF(i,1)=OutsRBF;
%     
% end
%     
% 
% ErRBF=sqrt((OutDesired-OutputRBF)'*(OutDesired-OutputRBF))/sqrt(OutDesired'*OutDesired);
% 
% E=[ErTLP,ErRBF]

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                            TIME FOR NICE COLORFUL PICTURES
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

[X,Y]=meshgrid(Ix,Iy);

n=1;
lenx=size(Ix);
leny=size(Iy);
for i=1:lenx(2)
    for j=1:leny(2)
        ODesired(i,j)=OutDesired(n,1);
        OTLP(i,j)=OutputTLP(n,1);
       % ORBF(i,j)=OutputRBF(n,1);
        if (ODesired(i,j)==0)
            ErTL(i,j)=0;
           % ErRBF(i,j)=0;
        else
            ErTL(i,j)=(ODesired(i,j)-OTLP(i,j))/ODesired(i,j)*100;
           % ErRBF(i,j)=(ODesired(i,j)-ORBF(i,j))/ODesired(i,j)*100;
        end
        n=n+1;
    end
end

figure (1)


subplot(2,2,1)
surf(X,Y,ODesired)
xlabel('x')
ylabel('y')
zlabel('Z(Analytical)')
axis([min(Ix),max(Ix),min(Iy),max(Iy),-1.2,1.2])
title(['Z=P0(x)*T1(y)'])
colorbar


subplot(2,2,2)
surf(X,Y,OTLP)
xlabel('x')
ylabel('y')
zlabel('Z(TLP)')
axis([min(Ix),max(Ix),min(Iy),max(Iy),-1.2,1.2])
title(['Z=P0(x)*T1(y)'])
colorbar


% subplot(2,2,3)
% surf(X,Y,ORBF)
% xlabel('x')
% ylabel('y')
% zlabel('Z(RBF)')
% axis([min(Ix),max(Ix),min(Iy),max(Iy),-1.2,1.2])
% title(['Z=P0(x)*T1(y)'])
% colorbar


 figure (2)
 
 subplot(2,2,1)
 contourf(X,Y,ODesired)
 xlabel('x')
 ylabel('y')
 zlabel('Desired')
 title(['P0(x)T1(y)-Exact'])
 colorbar
 
 
 subplot(2,2,2)
 contourf(X,Y,OTLP)
 xlabel('x')
 ylabel('y')
 zlabel('Z(TLP)')
 title(['P0(x)T1(y)-TLP'])
 colorbar
 
 
%  subplot(2,2,3)
%  contourf(X,Y,ORBF)
%  xlabel('x')
%  ylabel('y')
%  zlabel('Z(RBF)')
%  title(['P0(x)T1(y)-RBF'])
%  colorbar
 
 
 figure (3)
 
 zmin=1.1*(min(min(ErTL)));
 zmax=1.1*(max(max(ErTL)));
 
 subplot(2,2,1)
 surf(X,Y,ErTL)
 xlabel('x')
 ylabel('y')
 zlabel('ErrorTLP (%)')
% axis([min(Ix),max(Ix),min(Iy),max(Iy),zmin,zmax])
 colorbar
 
 
 
%  zmin=1.2*(min(min(ErRBF)));
%  zmax=1.2*(max(max(ErRBF)));
%  
%  subplot(2,2,2)
%  surf(X,Y,ErRBF)
%  xlabel('x')
%  ylabel('y')
%  zlabel('ErrorRBF (%)')
%  axis([min(Ix),max(Ix),min(Iy),max(Iy),zmin,zmax])
%  colorbar


% xmax=max(NitTLP);
% subplot(2,2,3)
% plot(NitTLP,ErrorTLP,'-r')
% axis([0,xmax,-Inf,Inf])
% set(gcf,'DefaultTextFontSize',[12]);
% xlabel('Number of Iterations')
% ylabel('Training Error(TLP)')
% grid on

