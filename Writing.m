function Writing(Ix1, Iy1, HidCtrRBF, HidVarRBF, OutWtsRBF, nunitsRBF,...
    OBWtRBF, Inputs, max1, max2, max3)

fid = fopen('MA', 'w');
fprintf(fid, '%i = Number of Input Mach Numbers\n', length(Ix1));
fclose(fid);
dlmwrite('MA', Ix1, '-append', 'delimiter','\t', 'newline','pc');

fid = fopen('RE', 'w');
fprintf(fid, '%i = Number of Input Reynolds Numbers\n', length(Iy1));
fclose(fid);
dlmwrite('RE', Iy1, '-append', 'delimiter','\t', 'newline','pc');

dlmwrite('HidCtrRBF', HidCtrRBF', 'delimiter','\t','precision','%.9f')

dlmwrite('HidVarRBF', HidVarRBF', 'delimiter','\t','precision','%.9f')

dlmwrite('OutWtsRBF', OutWtsRBF', 'delimiter','\t','precision','%.9f')

fid = fopen('RBF_INPUT', 'w');
fprintf(fid, '%i = Number of Hidden Units\n', nunitsRBF);
fprintf(fid, '%f = OB Weight\n', OBWtRBF);
fprintf(fid, '%i = Number of Inputs (Re, Ma, ... etc.)\n', length(Inputs(1,:)));
fprintf(fid, '%f = Normalization factor for the first input\n', max1);
fprintf(fid, '%f = Normalization factor for the second input\n', max2);
fprintf(fid, '%f = Normalization factor for the drag', max3);
fclose(fid);