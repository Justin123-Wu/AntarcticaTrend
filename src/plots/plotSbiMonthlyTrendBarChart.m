function plotSbiMonthlyTrendBarChart( vMonthlyTrend, begYear, endYear, interpMethod )
%vMonthlyTrend: numStations x 1 cell, each cell has
%                vMonthlyTrend{i}.name
%                vMonthlyTrend{i}.tab: 12 x 7, [month,strengthMean, strengthMedian, thicknessMean, thicknessMedian, #SBIs, #ofNonSBI];

%https://www.mathworks.com/help/matlab/ref/bar.html#bug9u7m-1

numStations = numel(vMonthlyTrend);

xTickValues = (1:numStations);
xTickLabels = cell(numStations,1);
xTickNoneLabels = cell(numStations,1);

y1 = zeros(numStations, 12);  %each station's SBI strength Mean for 12 months
y2 = zeros(numStations, 12);  %each station's SBI strength Median for 12 months
y3 = zeros(numStations, 12);  %each station's SBI thickness Mean for 12 months
y4 = zeros(numStations, 12);  %each station's SBI thickness Median for 12 months
y5 = zeros(numStations, 12);  %each station's # SBIs and the monthly frequency

for i=1:numStations
    xTickLabels{i} = vMonthlyTrend{i}.station;
    xTickNoneLabels{i} = '';
    y1(i, :) = vMonthlyTrend{i}.tab( :, 2 )';
    y2(i, :) = vMonthlyTrend{i}.tab( :, 3 )';
    y3(i, :) = vMonthlyTrend{i}.tab( :, 4 )';
    y4(i, :) = vMonthlyTrend{i}.tab( :, 5 )';
    y5(i, :) = vMonthlyTrend{i}.tab( :, 6 )';
end

x = {y1,y2,y3,y4, y5};

vYLabels1 = { 'strength', 'strength', 'thickness', 'thickness', 'SBI'};
vYLabels2 = { 'mean(C)', 'median(C)', 'mean(m)', 'median(m)', 'num'};

fig=figure;
for i=1:5
    subplot(5,1,i)
    bh = bar(x{i});
    myLim = adjustPlotLim(x{i}(:), 0.1);

    xticks( xTickValues );
    if i<5
        xticklabels( xTickNoneLabels );
    else
        xticklabels( xTickLabels );
        xtickangle(0);
    end
    bh(12).FaceColor = [225,86,75]/255;  %summer
    bh(1).FaceColor = [255, 0, 0]/255;     %summer
    bh(2).FaceColor = [230,155,134]/255;   %summer

    bh(3).FaceColor = [90,31,177]/255;         %fall
    bh(4).FaceColor = [0, 0,255]/255;           %fall
    bh(5).FaceColor = [54,54,154]/255;         %fall

    bh(6).FaceColor = [4, 204, 199]/255;        %winter
    bh(7).FaceColor = [31, 177, 163]/255;       %winter
    bh(8).FaceColor = [79, 129,129]/255;        %winter
    
    bh(9).FaceColor  = [2, 194, 52]/255;   %spring
    bh(10).FaceColor = [73, 253, 120]/255;  %spring
    bh(11).FaceColor = [142, 222, 161]/255;   %spring

    ylim( myLim );      
    

    ylabel( {vYLabels1{i},vYLabels2{i}} );
    if( i==1 )
        legend('Jan', 'Feb',  'Mar', 'Apr', 'May','Jun','Jul','Aug','Sep','Oct', 'Nov', 'Dec' );
        title( ['SBI Monthly Trend from ', num2str(begYear), ' to ', num2str(endYear),  ', interp: ', interpMethod] );
    end

    %xlim([0,m]);
    ax = gca;
    ax.FontSize = 15;
end
filename = fullfile('../data/processed', ...
    ['all-stations-SBI-monthly-tread-bar-chart-', num2str(begYear), '-', num2str(endYear), '-', interpMethod, '.png']);
disp(filename);
set(fig, 'PaperUnits', 'inches');
set(fig, 'PaperPosition', [0 0 15 8]); % [left, bottom, width, height]
print( fig, filename, '-dpng', '-r300');

end

