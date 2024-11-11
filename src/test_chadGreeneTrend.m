function test_chadGreeneTrend
%
% this function is used to test and understand chadGreeneTrend()
%
close all

addpath('./util');

Fs = 2;                % sampling rate (per unit time)
dt = 1/Fs;             % sampling time interval
t = (115:dt:145)';     % time vector sampled at Fs per unit time
y1 = 40*t + 123*rand(size(t)); % forced trend of 40 units y per second
y2 = 30*t + 456*rand(size(t)); % forced trend of 30 units y per second

%
LW=2;
figure
hold on;
plot(t,y1, 'r-+','linewidth', LW);
plot(t,y2,'b-*', 'linewidth', LW);
xlabel ( 'time (sec)');
ylabel ( 'signal');
leg = legend('y1= 40 t + 123 * rand(0,1)', 'y2= 30 t + 456 * rand(0,1)');
set(leg,'FontSize',25);
ax = gca;
ax.FontSize = 15;

% call chadGreeneTrend and check estimated slope
s = chadGreeneTrend([y1, y2], Fs);
size(s);
disp(s)
end