function plotTempMonthlyTrendBarChart( vMonthlyTrend, begYear, endYear, interpMethod )
%vMonthlyTrend: numStations x 1 cell, each cell has
%                vMonthlyTrend{i}.name
%                vMonthlyTrend{i}.tab: 12 x 7, [month,T0Mean, T0Median, T200Mean, T200Median, T500Mean, T500Median];
%https://www.mathworks.com/help/matlab/ref/bar.html#bug9u7m-1

numStations = numel(vMonthlyTrend);

xTickValues = (1:numStations);
xTickLabels = cell(numStations,1);
xTickNoneLabels = cell(numStations,1);

y1 = zeros(numStations, 12);  %each station's T0 mean  for 12 months
y2 = zeros(numStations, 12);  %each station's T0 median  for 12 months
y3 = zeros(numStations, 12);  %each station's T200 mean for 12 months
y4 = zeros(numStations, 12);  %each station's T200 Median for 12 months
y5 = zeros(numStations, 12);  %each station's T500 Mean for 12 months
y6 = zeros(numStations, 12);  %each station's T500 Median for 12 months

for i=1:numStations
    xTickLabels{i} = vMonthlyTrend{i}.station;
    xTickNoneLabels{i} = '';
    y1(i, :) = vMonthlyTrend{i}.tab( :, 2 )'; %T0 mean
    y2(i, :) = vMonthlyTrend{i}.tab( :, 3 )'; %T0 median
    y3(i, :) = vMonthlyTrend{i}.tab( :, 4 )'; %T200 mean
    y4(i, :) = vMonthlyTrend{i}.tab( :, 5 )'; %T200 median
    y5(i, :) = vMonthlyTrend{i}.tab( :, 6 )'; %T500 mean
    y6(i, :) = vMonthlyTrend{i}.tab( :, 7 )'; %T500 median
end

x = {y1,y2,y3,y4,y5,y6};

vYLabels1 = { 'T0', 'T0', 'T200-T0', 'T200-T0', 'T500-T0', 'T500-T0'};
vYLabels2 = { 'mean(C)', 'median(C)', 'mean(C)', 'median(C)', 'mean(C)', 'median(C)'};

fig = figure;
for i=1:6
    subplot(6,1,i)
    bh = bar(x{i});
    myLim = adjustPlotLim( x{i}(:), 0.1);
    
    xticks( xTickValues );
    if i<5
        xticklabels( xTickNoneLabels );
    else
        xticklabels( xTickLabels );
        xtickangle(0);
    end
    bh(12).FaceColor = [225,86,75]/255;    %summer
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

    ylabel( {vYLabels1{i}, vYLabels2{i}} );
    if( i==1 )
        legend('Jan', 'Feb',  'Mar', 'Apr', 'May','Jun','Jul','Aug','Sep','Oct', 'Nov', 'Dec' );
        title( ['Temperature Monthly Trend from ', num2str(begYear), ' to ', num2str(endYear),  ', interp: ', interpMethod] );       
    end

    %xlim([0,m]);
    ax = gca;
    ax.FontSize = 12;
end
filename = fullfile( '../data/processed', ...
    ['all-stations-Temp-monthly-tread-bar-chart-', num2str(begYear), '-', num2str(endYear), '-', interpMethod, '.png']);
disp(filename);
set(fig, 'PaperUnits', 'inches');
set(fig, 'PaperPosition', [0 0 15 8]); % [left, bottom, width, height]
print( fig, filename, '-dpng', '-r300'); % 300 DPI resolution

end

