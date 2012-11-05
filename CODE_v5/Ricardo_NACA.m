% This programs tests RBF for a given function
clear all; clc;% close all;

test = 3; %1 = testing the training pts, 2 = testing centers
span   = 25;
err_L2 = 0;
for q = 400:span:400
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                          GENERATE THE I/O PATTERN
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
train_pts_ma = 50;
train_pts_re = 100;
test_pts_ma  = 200; train_pts_ma;
test_pts_re  = 200; train_pts_re;
nunitsRBF    = q; % No.of Units in the Hidden Layer

map_max   = 1.75;
rep_max   = 10000;
map_min   = 0.1;
rep_min   = 200;

Ix1 = map_min:(map_max-map_min)/(train_pts_ma-1):map_max;
Ix1 = Ix1/map_max;
Iy1 = rep_min:(rep_max-rep_min)/(train_pts_re-1):rep_max;
Iy1 = Iy1/rep_max;

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
cd_max     = max(OutDesired);
OutDesired = OutDesired/cd_max;

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
% Writing(Ix1, Iy1, HidCtrRBF, HidVarRBF, OutWtsRBF, nunitsRBF,...
%     OBWtRBF, Inputs, map_max, rep_max, cd_max)
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                           TIME FOR NICE COLORFUL PICTURES
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
[Ix2 Iy2 ORBF Empirical] = interp_mantle(test_pts_ma, test_pts_re, map_max,...
    rep_max, map_min, rep_min, cd_max, HidCtrRBF,...
    HidVarRBF, OBWtRBF, OutWtsRBF, nunitsRBF);
odd = err_L2;
[err_loc err_L2] = error_analysis(ORBF, Empirical);

Plotting(test_pts_ma, test_pts_re, map_max, rep_max, map_min, rep_min,...
    cd_max, ORBF, Empirical, err_loc, err_L2);

if test == 1
    figure(100)
    plot([q-span, q], [odd, err_L2], '.-'), hold on
    title ('Number of Training Data Points vs. L2 Error')
    xlabel('Numer of training data points for Ma or Re')
    ylabel('L2 Error')
elseif test == 2
    figure(100)
    plot([q-span, q], [odd, err_L2], '.-'), hold on
    title ('Number of RBF centers vs. L2 Error')
    xlabel('Numer of training data points for Ma or Re')
    ylabel('L2 Error')
end
end
hold off