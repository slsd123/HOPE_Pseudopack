%Neural Network with PsuedoInverse
%Unsupervised training for Centers and Variance, Supervised Training for
%Weights

function[HidCtr,HidVar,OBWt,OutWts,Cluster]=Unspuer(nhidden,eta,inputv,outputv,niit,SpecError);




%__________________________________________________________________________
%                                  
%                                   PREPROCESSING
%__________________________________________________________________________



soutp=size(outputv); %Size of the Output Pattern Matrix
soutsp=soutp(1); %Total number of Output Patterns Vectors
noutput=soutp(2); %Total number of members in Each Output Pattern

sinp=size(inputv); %Size of the Input Pattern Matrix
ninput=sinp(2); %Total number of members in Each Input Pattern

flag=0;


%__________________________________________________________________________
%
%                         PART A: DETERMINATION OF THE CENTERS
%__________________________________________________________________________

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                          A1: Choose J Initial Cluster Centers
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



ss=(soutsp-rem(soutsp,nhidden+1))/(nhidden+1);
for i=1:nhidden
    kk=i*ss; %Extract a row number~First nHidden inputs are taken as centers
    for j=1:ninput
        
        HidCtr(i,j)=inputv(kk,j); % Assign Random Input Patterns as Centers
    end
end


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%            A2: While Stopping Condtion is False Execute Steps A3-A8
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



CtrError = 10;    %Initialize the CtrError to Large Value
OldCtr=HidCtr;    

Niterations=1; % Counter for the number of Iterations
ep=0; % Counter for the Epoch Number


while (CtrError>SpecError)
 %while(Niterations<niit)  
     
     for i=1:nhidden
        for j=1:ninput
            NewCtr(i,j)=zeros;
        end
    end
     
    
    for i=1:nhidden
        for j=1:soutsp
            Cluster(i,j)=0;
        end
    end
    
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    %          A3: For Each Input Pattern do Steps A4-A6
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    for kk=1:soutsp
        
                             
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        %             A4: Present an input pattern
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        for i=1:ninput
            
            Inputs(1,i)=inputv(kk,i); %Extract the Reqd Inputs
        end
        
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        %            A5: Calculate the Minimum 'Dist'
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    
        %Calculate The Norm from Each Center
    
        for j=1:nhidden
              
            for k=1:ninput
                d(k,1)= Inputs(1,k)-HidCtr(j,k);%Dis From CTR
            end 
            JNorm(j)=d'*d;   %Distance from the J-th Vector
        
        end
         
        %Find the Minimum Value
        
        min=1;
        minValue=JNorm(1);
        
        for j=2:nhidden
            for ss=2:j
                if (JNorm(j)<minValue)
                    min=j;
                    minValue=JNorm(j);
                end
            end
        end
       
       %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
       %      A6: Assign the pattern to the correct cluster
       %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      
      %Count the no. of members in the Cluster
      Cluster(min,1)=Cluster(min,1)+1;
      jj=Cluster(min,1);
      Cluster(min,jj+1)=kk;    
      
    end %End of presenting a batch
    
    
       
    
    
       
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    %                  A7: Update The Center
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    for j=1:nhidden %Do for Each Cluster
        jj=Cluster(j,1);%Total number of members in each Cluster
        for l=1:jj %Do for Each Member of the Cluster
            ro=Cluster(j,l+1);  %Extract The Row No. of the Input Vector
            for m=1:ninput %Do for Each Member of Input Vector
                NewCtr(j,m)=NewCtr(j,m)+inputv(ro,m); %Update NewCtr
            end %Done for Each Member of Input Vector
        end %Done for Each Member of the Cluster
        
        for m=1:ninput
            NewCtr(j,m)=NewCtr(j,m)/jj; %Completion of Update Process
        end
    end
    
    
    
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    %                A8: Compare Stopping Condition
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    NumErr=0;
    DenoErr=0;
    for j=1:nhidden
        for k=1:ninput
            NumErr=NumErr+(NewCtr(j,k)-OldCtr(j,k))^2;
            DenoErr=DenoErr+(OldCtr(j,k))^2;
        end
    end
    
    CtrError=NumErr/DenoErr; %Error Value
    
    OldCtr=NewCtr;
    
    Niterations=Niterations+1;
    
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                             A9: Update the Center
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

HidCtr=NewCtr;


%__________________________________________________________________________
%
%                                 END OF PART A
%__________________________________________________________________________

%                             *********************  





%__________________________________________________________________________
%
%                            PART B: DETERMINATION 0F VARIANCE
%__________________________________________________________________________

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                             B1: Initialize Variance
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

HidVar(nhidden,1)=zeros;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                            B2: Take the Variance to be equal to
%                                the mean distance of every center
%                                from a few neighboring center
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

for j=1:nhidden
    d1=0;
    d2=0;
    d3=0;%%%%%%%%%%%%
    d4=0;%%%%%%%%%%%%
     for i=1:ninput
         if (j~=1)
            d1=d1+(HidCtr(j-1,i)-HidCtr(j,i))^2; %Distance from the Preceeding Center
          end
         
         if (j~=nhidden)
            d2=d2+(HidCtr(j,i)-HidCtr(j+1,i))^2; % Distance from the Succeding Center
         end
         
     end
     
%      if (j==1)
%          d=0.5*(sqrt(d2)+sqrt(d4));
%      end
%      if (j==2)
%          d=(sqrt(d1)+sqrt(d2)+sqrt(d4))/3;
%      end
%      
%      if (j==nhidden)
%          d=0.5*(sqrt(d1)+sqrt(d3));
%      end
%      
%      if (j==nhidden-1)
%          d=(sqrt(d1)+sqrt(d2)+sqrt(d3))/3;
%      end
%      
%      if ((j>2)&&(j<nhidden-1))
%          d = 0.25*(sqrt(d1)+sqrt(d2)+sqrt(d3)+sqrt(d4));
%      end
         
    
     
     if (j==1)
         d=sqrt(d2);
     else if (j==nhidden)
             d=sqrt(d1);
         else
             d=0.5*(sqrt(d1)+sqrt(d2));
         end
    end
     
     HidVar(j)=d;
      
       
end

%__________________________________________________________________________
%
%                                   END OF PART B
%__________________________________________________________________________
%                                 ******************



%__________________________________________________________________________
%
%                         PART C: Calculate OutputWeights
%__________________________________________________________________________





%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                        C1: Solve the Linear System of Equations
%                        [(Phi)'(Phi)]W=(Phi)'T
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


T=outputv;%Create the Output Matrix
Phi=zeros(soutsp,nhidden+1); %Initialize the Input Information Matrix

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                     C2: Present an I/O Pattern
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
for i=1:soutsp %For Each Member in a Batch
          
    % Input Pattern
    for j=1:ninput
        Inputs(1,j)=inputv(i,j);
    end
                    
                 
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    %              C3: An Input Vector Calculates
    %                  its distance from each center,
    %                  divides it by the covariance
    %                  and obtains the output of the 
    %                  j-th hidden layer
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
          
          
    %Distance Calculation~Norm Calculation
        
    for j=1:nhidden
        for k=1:ninput
            d(k,1)= Inputs(1,k)-HidCtr(j,k);
        end 
            
        JNorm(j)=d'*d;   %Distance from the J-th Vector
        JNorm(j)=0.5*JNorm(j)/((HidVar(j))^2);
        HidOut(1,j)=exp(-1*0.5*JNorm(j)); %Output of the Hidden Layer
            
        Phi(i,j+1)=HidOut(1,j); %Set up the Input Information Matrix
          
    end
          
    Phi(i,1)=1; % The Bias Information 
          
end %Finished Presenting a Batch 

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                        C4: PREPARING TO FIND THE WEIGHTS
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      
A = Phi'*Phi;
%DIMCHECK: nHidxnHid=(nHidxsoutsp)x(soutspxnHid)
B = Phi'*T;
%DIMCHECK: nHidxnOutput=(nHidxsoutsp)x(soutspxnOutput)
      
W=linsolve(A,B); %Bias-Weight Matrix
W=W'; %For Consistency
%DIMCHECK: nOutputxnHid


%Prepare the Return Variables      
for i=1:noutput
     OBWt(i,1)=W(i,1); %Bias Vector
     for j=2:nhidden+1
         OutWts(i,j-1)=W(i,j); %Weight Matrix
     end
end
          
%__________________________________________________________________________
%
%                          END OF WEIGHT UPDATE
%__________________________________________________________________________

      
      
      
      

    
    




            

    
    
    
    
    
    
      
      
    
    
    
    


