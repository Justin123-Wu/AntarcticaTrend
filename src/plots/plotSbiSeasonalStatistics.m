function plotSbiSeasonalStatistics( tab, stationName )
%tab: n x 9, [year, seasonCode(1-summer,2-fall,3-winter,4-spring), #ofSBI, #ofnonSBI, sbiMonthlyFreq, sbiStrengthMean, sbiStrengthMedian, sbiThicknessMean, sbiThicknessMedian];

[m,n] = size(tab);
xTickValues = (1:4:m);
nTicks = numel(xTickValues);
xTickLabels = cell(nTicks,1);
for i=1:nTicks
    rowId = xTickValues(i);
    xTickLabels{i} = num2str(tab(rowId,1));
end


x = (1:m);
figure
subplot(2,1,1)
hold on;
%yyaxis left
plot( x, tab(:, 3), '-+',  'color', [0, 0, 255/255] );   %# of SBI
plot( x, tab(:, 4), '--o', 'color', [0, 1, 0] );  %# of NON-SBI
ylabel( "SBI/NON-SBI Nmuber");
ylim([0,130]);  %4*31  = 124

%yyaxis right
%plot( x, tab(:, 5), '-x', 'color', [200/255, 0, 0]  )
%ylim([0,1.1]);
%ylabel( "SBI Freq");

legend( 'Number of SBI', 'Number of non-SBI');
xticks( xTickValues );
xticklabels( xTickLabels );
xtickangle(45);
%xlabel( "Year");
xlim([0,m]);
title( ['Seasonal SBI and non-SBI Statistics for station: ',  stationName]);

ax = gca;
ax.FontSize = 16; 

subplot(2,1,2)
hold on;
yyaxis left
ha = plot( x, tab(:, 6), '-+', 'color', [0, 0, 155/255]  );
hb = plot( x, tab(:, 7), '--o', 'color', [0, 0, 240/255]  );
ylabel( "SBI Strength (C)");

yyaxis right
hc = plot( x, tab(:, 8), '-+', 'color', [100/255, 0, 0]  );
hd = plot( x, tab(:, 9), '--o', 'color', [200/255, 0, 0]  );
ylabel( "SBI rhickness (m)");

legend( [ha,hb,hc,hd], 'SBI Strength Mean', 'SBI Strength median', 'SBI Thickness mean', 'SBI Thickness median');
xticks( xTickValues );
xticklabels( xTickLabels );
xtickangle(45);
xlabel( "Year");
xlim([0,m]);
%title( ['The mean and median of SBI strength and thickness for ',  stationName]);
ax = gca;
ax.FontSize = 16; 
savefig( ['./fig/',stationName, '-SBI-seasonal-statistics.fig'])

end

