% This program plots the results from the RBF data
function Plotting(test_pts_ma, test_pts_re, map_max,...
    rep_max, map_min, rep_min, cd_max, ORBF, Empirical, err_loc, err_L2)

Ix2 = map_min:(map_max-map_min)/(test_pts_ma-1):map_max;
Ix2 = Ix2/map_max;
Iy2 = rep_min:(rep_max-rep_min)/(test_pts_re-1):rep_max;
Iy2 = Iy2/rep_max;

[X2,Y2]=meshgrid(Ix2,Iy2);

figure(1)

subplot(2,2,1)
surf(X2,Y2,Empirical,'EdgeColor','none')
xlabel(['M/' num2str(map_max)])
ylabel(['Re/' num2str(rep_max)])
zlabel('Drag(RBF)')
axis([min(Ix2), max(Ix2), min(Iy2), max(Iy2), 0, cd_max*1.25])
title(['Empirical Formula (Training Data)'])
colorbar

subplot(2,2,2)
contourf(X2,Y2,Empirical)
xlabel(['M/' num2str(map_max)])
ylabel(['Re/' num2str(rep_max)])
zlabel('Drag(RBF)')
title(['Empirical Formula (Training Data)'])
colorbar

subplot(2,2,3)
surf(X2,Y2,ORBF,'EdgeColor','none')
xlabel(['M/' num2str(map_max)])
ylabel(['Re/' num2str(rep_max)])
zlabel('Drag(RBF)')
axis([min(Ix2),max(Ix2), min(Iy2) ,max(Iy2), 0, cd_max*1.25])
title(['Drag Coefficient-RBF'])
colorbar

subplot(2,2,4)
contourf(X2,Y2,ORBF)
xlabel(['M/' num2str(map_max)])
ylabel(['Re/' num2str(rep_max)])
zlabel('Drag(RBF)')
title(['Drag Coefficient-RBF'])
colorbar

figure(2)

subplot(1,2,1)
surf(X2,Y2,ORBF,'EdgeColor','none')
xlabel(['M/' num2str(map_max)])
ylabel(['Re/' num2str(rep_max)])
zlabel('Drag(RBF)')
% axis([min(Ix2),max(Ix2),min(Iy2),max(Iy2),0.3,1.4])
caxis([0 1.7])
title(['NACA'])
colorbar

subplot(1,2,2)
contourf(X2,Y2,ORBF)
xlabel(['M/' num2str(map_max)])
ylabel(['Re/' num2str(rep_max)])
zlabel('Drag(RBF)')
title(['Drag Coefficient-RBF'])
colorbar

figure(3)
surf(Y2,X2,err_loc', 'EdgeColor', 'None')
xlabel(['M/' num2str(map_max)])
ylabel(['Re/' num2str(rep_max)])
title(['Local error plot with an L2 error = ' num2str(err_L2)])