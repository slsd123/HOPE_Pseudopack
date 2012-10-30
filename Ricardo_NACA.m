% This programs tests RBF for a given function
clear all; clc;% close all;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                          GENERATE THE I/O PATTERN
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
train_pts = 125;
test_pts  = 125;
nunitsRBF = 1000; % No.of Units in the Hidden Layer

map_max   = 1.75;
rep_max   = 100000;
map_min   = 0.1;
rep_min   = 200;

n1=1;
p1=1;

Ix1 = map_min:(map_max-map_min)/(train_pts-1):map_max;
Ix1  = Ix1/map_max;
Iy1 = rep_min:(rep_max-rep_min)/(train_pts-1):rep_max;
Iy1  = Iy1/rep_max;

for i = 1:length(Iy1)
    Inputs(length(Ix1)*(i-1)+1:length(Ix1)*i,1) = Ix1;
end
for i = 1:length(Iy1)
    Inputs(length(Ix1)*(i-1)+1:length(Ix1)*i,2) = Iy1(i);
end

for i=1:length(Inputs(:,1))
    map = Inputs(i,1)*map_max;
    rep = Inputs(i,2)*rep_max;

    OutDesired(i,1) = (24.0/rep+0.38+4.0/sqrt(rep))*...
        (1.0+exp(-0.43/(map^4.67)));
end
cd_max = max(OutDesired);
OutDesired = OutDesired/cd_max;

N1=n1;

OUTP=OutDesired;
%%
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                        DESIGN OF THE RADIAL BASIS FUNCTION NETWORK
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
a = 'Begin building ANN'
tic
% [HidCtrRBF,HidVarRBF,OBWtRBF,OutWtsRBF,ClusterRBF]=...
%     UnSupRBF(nunitsRBF,0.02,Inputs,OutDesired,3200,0.01);
[HidCtrRBF,HidVarRBF,OBWtRBF,OutWtsRBF,ClusterRBF]= ...
    UnspuerRBF(nunitsRBF,0.02,Inputs,OutDesired,3200,0.001);
toc
a = 'ANN Built'

%%
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                                TESTING THE RBF NETWORK
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
%% Write to a file
Writing(Ix1, Iy1, HidCtrRBF, HidVarRBF, OutWtsRBF, nunitsRBF,...
    OBWtRBF, Inputs, map_max, rep_max, cd_max)
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                           TIME FOR NICE COLORFUL PICTURES
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Plotting(test_pts, map_max, rep_max, map_min, rep_min, cd_max, HidCtrRBF,...
    HidVarRBF, OBWtRBF, OutWtsRBF, nunitsRBF)