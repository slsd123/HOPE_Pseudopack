% Three Layer Back Propagation Neural Network

function[HidWts1,HidWts2,OutWts,HBWt1,HBWt2,OBWt,Error,Nit]=ThreeLP(nhidden1,nhidden2,eta,inputv,outputv,niit,SpecError);


%**************************************************************************
%                                  PREPROCESSING
%**************************************************************************



soutp=size(outputv); %Size of the Output Pattern
soutsp=soutp(1); %Total number of Output Patterns
noutput=soutp(2); %Total number of members in Each Output Pattern

sinp=size(inputv); %Size of the Input Pattern
ninput=sinp(2); %Total number of members in Each Input Pattern


%**************************************************************************
%                             0: Initialize the Weights
%**************************************************************************

%Initialize the Output-Layer Weights & Biases
%Initialize the weights to a number between 1 & 10
for i=1:noutput;
    for j=1:nhidden2
        OutWts(i,j)=j/(10*nhidden2);
    end
end
OBWt=[1:noutput]; % Bias Terms
OBWt=OBWt/(2*noutput); %Normalize the Bias Wts
OBWt=OBWt'; %For consistency, this is a row vector


%Initialize the Second Hidden-Layer Weights & Biases
for i=1:nhidden2
    for j=1:nhidden1
        HidWts2(i,j)=1/(1000);
    end
end
HBWt2=[1:nhidden2]; %Bias Terms
HBWt2=HBWt2/(2*nhidden2);  %Normalize the Bias Wts
HBWt2=HBWt2'; % For consistency, this is a row vector

%Initialize the Second Hidden-Layer Weights & Biases
for i=1:nhidden1
    for j=1:ninput
        HidWts1(i,j)=1/(1000);
    end
end
HBWt1=[1:nhidden1]; %Bias Terms
HBWt1=HBWt1/(2*nhidden1);  %Normalize the Bias Wts
HBWt1=HBWt1'; % For consistency, this is a row vector


%Counting the number of Iterations

Niterations=1;



%**************************************************************************
%                   1: While Stopping Condition is False do steps 2:9
%**************************************************************************

%Defining the Stopping Condition

CumErr=10; % Initializing the Cumulative Error to a Large Value
CumErrD=10;

TestErr=10;




while (TestErr>SpecError)
%while (Niterations<niit)

      
    
    %**********************************************************************
    %                2: For Each Training Pair do Steps 3:8
    % *********************************************************************
    
    
    CumErr=0;
    CumErrD=0;
        
    for ro=1:soutsp
            
        for i=1:noutput
            OutDesired(1,i)=outputv(ro,i); % Extract the Targetted Outputs
        end
            
        for i=1:ninput
            Inputs(1,i)=inputv(ro,i);    %Extract The Inputs
        end
    
     
        %_____________________________________________________________________
        %                              FEEDFORWARD
     
     
            %*************************************************************
            %                  3: Each Unit Receives Input Signal
            %                     and broadcasts this to the unit
            %                     above it
            %*************************************************************
     
            %**************************************************************
            %                  4: Each Hidden Unit of the First Hidden 
            %                     Layer Receives this Signal, sums it, 
            %                     applies the activation function and 
            %                     broadcasts this to the Second Layer.
            %*************************************************************
        
        
            [HidOut1,HidFdash1]=Sigmoid(HBWt1+(HidWts1*Inputs')); 
            % DIMCHECK: nhidden1 x 1= (nhidden1 x ninput)*(ninput x 1)
        
            HidOut1=HidOut1'; % For Consistency, it is a column vector
            HidFdash1=HidFdash1';
            
            
            %**************************************************************
            %                  5: Each Hidden Unit of the Second Hidden 
            %                     Layer Receives this Signal, sums it, 
            %                     applies the activation function and 
            %                     broadcasts this to the Output Layer.
            %**************************************************************
            
            [HidOut2,HidFdash2]=Sigmoid(HBWt2+(HidWts2*HidOut1')); 
            % DIMCHECK: nhidden2 x 1= (nhidden2 x nhidden1)*(nhidden1 x 1)
        
            HidOut2=HidOut2'; % For Consistency, it is a column vector
            HidFdash2=HidFdash2';
            
        
        
            %*************************************************************
            %                   6: Each Output Unit Sums its Weighted
            %                      Input and Applies its Activation
            %                      Function to Compute its Output
            %************************************************************
        
            [Outs,OutFdash]=Sigmoid(OBWt + (OutWts*HidOut2'));
            %DIMCHECK: noutput x 1 = (noutput x nhidden2)*(nhidden2 x 1)
        
            Outs=Outs'; % For consistency, this is a column vector
            OutFdash=OutFdash'; % Column Vector 
        
        
        %                              END OF FEEDFORWARD
        %_____________________________________________________________________
     
     
     
     
     
        %_____________________________________________________________________
        %                              BACKPROPAGATION
     
     
            %***********************************************************
            %                       7. Each Output Unit (1:noutput)
            %                          receives a target pattern, &
            %                          computes its error info term
            %***********************************************************
        
            OutError=OutDesired-Outs; % NOT the error; just a temp. var.
        
            for i=1:noutput
                delOut(1,i)=OutError(1,i)*OutFdash(1,i); %Error-Info Term
            end
        
            %************************************************************
            %                  Calculate the Weight Correction Term
            %************************************************************
        
            delOutWts=eta*delOut'*HidOut2; %Weight Corr Term
            %DIMCHECK: (noutput x nhidden2)=(noutput x 1)*(1 x nhidden2)
        
            delOBWt=eta*delOut';%Bias Correction Term
            %DIMCHECK: (noutput x1) = (noutput x 1)
        
        
            %************************************************************
            %                      8. Each Hidden Unit of the second 
            %                         hidden layer sums its
            %                         delta inputs (from the upper
            %                         layer),multiplies by derivative
            %                         of its activation func. to find
            %                         its error-information term
            %************************************************************
        
            HidError2=delOut*OutWts; % NOT the error; just a temp. var.
            %DIMCHECK: (1 x nhidden2)=(1 x noutput)*(noutput x nhidden2)
        
            for i=1:nhidden2
                delHid2(1,i)=HidError2(1,i)*HidFdash2(1,i); %Error-Info Term
            end
        
            %*********************************************************
            %               Calculate the Weight Correction Term
            %*********************************************************
        
            delHidWts2=eta*delHid2'*HidOut1; %Weight Correction Term
            %DIMCHECK: (nhidden2 x nhidden1)=(nhidden2 x 1)*(1 x nhidden1)
        
            delHBWt2=eta*delHid2';
            %DIMCHECK: (nhidden2 x 1)= (nhidden2 x 1)
            
            %************************************************************
            %                      9. Each Hidden Unit of the First 
            %                         hidden layer sums its
            %                         delta inputs (from the upper
            %                         layer),multiplies by derivative
            %                         of its activation func. to find
            %                         its error-information term
            %************************************************************
        
            HidError1=delHid2*HidWts2; % NOT the error; just a temp. var.
            %DIMCHECK: (1 x nhidden1)=(1 x nhidden2)*(nhidden2 x nhidden1)
        
            for i=1:nhidden1
                delHid1(1,i)=HidError1(1,i)*HidFdash1(1,i); %Error-Info Term
            end
        
            %*********************************************************
            %               Calculate the Weight Correction Term
            %*********************************************************
        
            delHidWts1=eta*delHid1'*Inputs; %Weight Correction Term
            %DIMCHECK: (nhidden1 x ninputs)=(nhidden1 x 1)*(1 x ninputs)
        
            delHBWt1=eta*delHid1';
            %DIMCHECK: (nhidden1 x 1)= (nhidden1 x 1)
                  
        
            %********************************************************
            %                       10. Update the Weights
            %********************************************************
        
            OutWts=OutWts+delOutWts;  % Update the Output Weights
            OBWt=OBWt+delOBWt;        %Update the Output Bias
        
            HidWts2=HidWts2+delHidWts2; %Update the 2nd Hidden Weights
            HBWt2=HBWt2+delHBWt2;
            
            HidWts1=HidWts1+delHidWts1; %Update the 1st Hidden Weights
            HBWt1=HBWt1+delHBWt1;
        
        
        %                              END OF BACK-PROPAGATION   
        %_____________________________________________________________________
     
     
     
        %*********************************************************************
        %                        11. Test-Stopping Condition
        %*********************************************************************
     
        Output=Sigmoid(OBWt+(OutWts*Sigmoid(HBWt2+(HidWts2*Sigmoid(HBWt1+(HidWts1*Inputs'))))));
        %DIMCHECK: (noutput x nhidden)*[(nhidden x ninputs)*(ninputs x 1)]
     
        Output=Output'; %For Consistency
     
        Err=0.5*((Output-OutDesired)*(Output-OutDesired)');
        ErrD=0.5*(OutDesired)*(OutDesired)';
        
        CumErr=CumErr+Err;
        CumErrD=CumErrD+ErrD;
        
   end   %End of an Epoch
   
   TestErr=CumErr/CumErrD;
   ErTLP=TestErr
            
        
  Nit(Niterations)=Niterations;
  Error(Niterations)=Err;
        
  Niterations=Niterations+1;
        
        
     
end       % End of While Loop
     
     
     
     
     
     
        
        
    
     
     
     