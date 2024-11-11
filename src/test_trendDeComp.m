function test_trendDeComp
%
% this function is used to test and understand trenddecomp()
%
close all

addpath('./coreAlg');

n=200;
t = (1:n)';
trend = 0.001*(t-100).^2;
period1 = 20;
period2 = 30;
seasonal1 = 2*sin(2*pi*t/period1);
seasonal2 = 0.75*sin(2*pi*t/period2);
noise = 2*(rand(n,1) - 0.5);
x = trend + seasonal1 + seasonal2 + noise;


figure
hold on
LW=2;
plot(t, trend, 'g--', 'linewidth', LW );
plot(t, seasonal1, 'b--', 'linewidth', LW);
plot(t, seasonal2, 'k--', 'linewidth', LW);
plot(t, noise, 'c--', 'linewidth', LW);
plot(t, x, 'r-', 'linewidth', LW);
leg = legend('$trend=0.001(t-100)^2$', '$s1=2sin(2\pi\frac{1}{20}t)$', '$s2=0.75sin(2\pi\frac{1}{30}t)$', '$\epsilon \sim  U(-1,1)$', '$x=trend+s1+s2+\epsilon$');
set(leg, 'Interpreter','latex');
set(leg,'FontSize',25);

xlabel('time (sec)');
ylabel('signal');
xlim([min(t),max(t)]);
%ylim([-4,13])
ax = gca;
ax.FontSize = 25;

[LT,ST,R] = trenddecomp(x);
%LT: n x 1;
%ST: n x 2;
%R:  n x 1;

figure
subplot(1,2,1)
plot(t, x, 'r-','linewidth', LW);
legend("x: input signal")
ax = gca;
ax.FontSize = 25;
xlabel('time (sec)');
ylabel('signal');

subplot(1,2,2)
hold on;
plot(t, LT, 'g-','linewidth', LW);
plot(t, ST(:,1), 'b-','linewidth', LW);
plot(t, ST(:,2), 'k-','linewidth', LW);
plot(t, R, 'c-','linewidth', LW);
legend("Long-term","Seasonal Term 1","Seasonal Term 2","Remainder")
ax = gca;
ax.FontSize = 25;
xlabel('time (sec)');
ylabel('signal');
end
