function [Ix2 Iy2 ORBF Empirical] = interp_mantle(test_pts_ma, test_pts_re, map_max, rep_max, map_min, rep_min,...
    cd_max, HidCtrRBF, HidVarRBF, OBWtRBF, OutWtsRBF, nunitsRBF)

Ix2 = map_min:(map_max-map_min)/(test_pts_ma-1):map_max;
Ix2 = Ix2/map_max;
Iy2 = rep_min:(rep_max-rep_min)/(test_pts_re-1):rep_max;
Iy2 = Iy2/rep_max;

for i = 1:length(Iy2)
    Inputs2(length(Ix2)*(i-1)+1:length(Ix2)*i,2) = Iy2(i);
end
for i = 1:length(Iy2)
    Inputs2(length(Ix2)*(i-1)+1:length(Ix2)*i,1) = Ix2;
end

a = 'Building grid'

tic
for i=1:length(Ix2)
    Input(1,1)=Ix2(i);
    map = Ix2(i)*map_max;
    for j=1:length(Iy2)
        Input(1,2)=Iy2(j);
        rep = Iy2(j)*rep_max;
        
        OutsRBF=OBWtRBF;
        
        for k=1:nunitsRBF
            JNormRBF       = 0;
            d              = Input(1,1)-HidCtrRBF(k,1);       %Dis From CTR
            JNormRBF       = JNormRBF+d*d;
            d              = Input(1,2)-HidCtrRBF(k,2);       %Dis From CTR
            JNormRBF       = JNormRBF+d*d;                    %J-th Norm
            JNormRBF       = 0.5*JNormRBF/((HidVarRBF(k))^2);
            HidOutRBF      = exp(-1*0.5*JNormRBF);
            OutsRBF        = OutsRBF + OutWtsRBF(k)*HidOutRBF;
        end
        
        ORBF  (j,i) = OutsRBF*cd_max;
        Empirical(j,i) = (24.0/rep+0.38+4.0/sqrt(rep))*...
            (1.0+exp(-0.43/(map^4.67)));
        
    end
end

toc
a = 'Grid built'

% ORBF = ORBF'*cd_max;