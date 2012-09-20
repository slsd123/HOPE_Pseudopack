load Qfp_Xp_JP.dat
load Qfp_Xp_Old.dat

Np = 77;
Xp = linspace(-3,2,Np);

Qfp_Xp_Exact(:,1) =   Xp.^3 -  3*Xp.^2  + 11*Xp - 7; 
Qfp_Xp_Exact(:,2) =  -Xp.^3 +  2*Xp.^2 -  4*Xp + 11;
Qfp_Xp_Exact(:,3) = 2*Xp.^3 - 11*Xp.^2         +  2;

% plot for rho
% ============
figure(1)

subplot(2, 2, 1)
plot(Xp, Qfp_Xp_Exact(:,1), 'k-o', Xp, Qfp_Xp_Old(:,1), 'k-*', 'linewidth',2,'markersize',6)
my_legend=legend('Exact', 'Approximation - Current code');
xlabel('$X_{p}$','FontSize',14,'Interpreter','Latex');
ylabel('$\rho(X_{p})$','FontSize',14,'Interpreter','Latex');
set(gca,'FontSize',12);

subplot(2, 2, 2)
plot(Xp, Qfp_Xp_Exact(:,1), 'k-o', Xp, Qfp_Xp_JP(:,1), 'k-*', 'linewidth',2,'markersize',6)
my_legend=legend('Exact', 'Approx-Modified code');
xlabel('$X_{p}$','FontSize',14,'Interpreter','Latex');
ylabel('$\rho(X_{p})$','FontSize',14,'Interpreter','Latex');
set(gca,'FontSize',12);

subplot(2, 2, 3)
plot(Xp,abs(Qfp_Xp_Exact(:,1) - Qfp_Xp_Old(:,1)),'k-*', 'linewidth',2,'markersize',6);
my_legend=legend('Error-Current code');
xlabel('$X_{p}$','FontSize',14,'Interpreter','Latex');
ylabel('| Exact - Approx |','FontSize',14);
set(gca,'FontSize',12);

subplot(2, 2, 4)
plot(Xp,abs(Qfp_Xp_Exact(:,1) - Qfp_Xp_JP(:,1)),'k-*', 'linewidth',2,'markersize',6);
my_legend=legend('Error-Modified code');
xlabel('$X_{p}$','FontSize',14,'Interpreter','Latex');
ylabel('| Exact - Approx |','FontSize',14);
set(gca,'FontSize',12);

% plot for rho * u
% ================
figure(2)

subplot(2, 2, 1)
plot(Xp, Qfp_Xp_Exact(:,2), 'k-o', Xp, Qfp_Xp_Old(:,2), 'k-*', 'linewidth',2,'markersize',6)
my_legend=legend('Exact', 'Approximation - Current code');
xlabel('$X_{p}$','FontSize',14,'Interpreter','Latex');
ylabel('$\rho\cdot u(X_{p})$','FontSize',14,'Interpreter','Latex');

subplot(2, 2, 2)
plot(Xp, Qfp_Xp_Exact(:,2), 'k-o', Xp, Qfp_Xp_JP(:,2), 'k-*', 'linewidth',2,'markersize',6);
my_legend=legend('Exact', 'Approx-Modified code');
xlabel('$X_{p}$','FontSize',14,'Interpreter','Latex');
ylabel('$\rho\cdot u(X_{p})$','FontSize',14,'Interpreter','Latex');
set(gca,'FontSize',12);

subplot(2, 2, 3)
plot(Xp,abs(Qfp_Xp_Exact(:,2) - Qfp_Xp_Old(:,2)),'k-*', 'linewidth',2,'markersize',6);
my_legend=legend('Error-Current code');
xlabel('$X_{p}$','FontSize',14,'Interpreter','Latex');
ylabel('| Exact - Approx |','FontSize',14);
set(gca,'FontSize',12);

subplot(2, 2, 4)
plot(Xp,abs(Qfp_Xp_Exact(:,2) - Qfp_Xp_JP(:,2)),'k-*', 'linewidth',2,'markersize',6);
my_legend=legend('Error-Modified code');
xlabel('$X_{p}$','FontSize',14,'Interpreter','Latex');
ylabel('| Exact - Approx |','FontSize',14);
set(gca,'FontSize',12);

% plot for E
% ==========
 figure(3)

subplot(2, 2, 1)
plot(Xp, Qfp_Xp_Exact(:,3), 'k-o', Xp, Qfp_Xp_Old(:,3), 'k-*', 'linewidth',2,'markersize',6);
my_legend=legend('Exact', 'Approximation - Current code');
xlabel('$X_{p}$','FontSize',14,'Interpreter','Latex');
ylabel('$E(X_{p})$','FontSize',14,'Interpreter','Latex');
set(gca,'FontSize',12);

subplot(2, 2, 2)
plot(Xp, Qfp_Xp_Exact(:,3), 'k-o', Xp, Qfp_Xp_JP(:,3), 'k-*', 'linewidth',2,'markersize',6);
my_legend=legend('Exact', 'Approx-Modified code');
xlabel('$X_{p}$','FontSize',14,'Interpreter','Latex');
ylabel('$E(X_{p})$','FontSize',14,'Interpreter','Latex');
set(gca,'FontSize',12);

subplot(2, 2, 3)
plot(Xp,abs(Qfp_Xp_Exact(:,3) - Qfp_Xp_Old(:,3)),'k-*', 'linewidth',2,'markersize',6);
my_legend=legend('Error-Current code');
xlabel('$X_{p}$','FontSize',14,'Interpreter','Latex');
ylabel('| Exact - Approx |','FontSize',14);
set(gca,'FontSize',12);

subplot(2, 2, 4)
plot(Xp,abs(Qfp_Xp_Exact(:,3) - Qfp_Xp_JP(:,3)),'k-*', 'linewidth',2,'markersize',6);
my_legend=legend('Error-Modified code');
xlabel('$X_{p}$','FontSize',14,'Interpreter','Latex');
ylabel('| Exact - Approx |','FontSize',14);
set(gca,'FontSize',12);