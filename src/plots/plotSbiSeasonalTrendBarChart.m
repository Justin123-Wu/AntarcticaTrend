function plotSbiSeasonalTrendBarChart( vSeasonalTrend, begYear, endYear, interpMethod )
%vSeasonalTrend: numStations x 1 cell, each cell has
%                seasonalTrend.name
%                seasonalTrend.tab: 4 x 7, [seasonCode,strengthMean, strengthMedian, thicknessMean, thicknessMedian, SBI NUM, NonSBI Num];

%https://www.mathworks.com/help/matlab/ref/bar.html#bug9u7m-1

numStations = numel(vSeasonalTrend);

xTickValues = (1:numStations);
xTickLabels = cell(numStations,1);
xTickNoneLabels = cell(numStations,1);

y1 = zeros(numStations, 4);  %each station's SBI strengthMean for four seasons
y2 = zeros(numStations, 4);  %each station's SBI strengthMedian for four seasons
y3 = zeros(numStations, 4);  %each station's SBI thickness Mean for four seasons
y4 = zeros(numStations, 4);  %each station's SBI thickness Median for four seasons
y5 = zeros(numStations, 4);  %each station's SBI seanonal Freq.

for i=1:numStations
    xTickLabels{i} = vSeasonalTrend{i}.station;
    xTickNoneLabels{i} = '';
    y1(i, :) = vSeasonalTrend{i}.tab( :, 2 )';
    y2(i, :) = vSeasonalTrend{i}.tab( :, 3 )';
    y3(i, :) = vSeasonalTrend{i}.tab( :, 4 )';
    y4(i, :) = vSeasonalTrend{i}.tab( :, 5 )';
    y5(i, :) = vSeasonalTrend{i}.tab( :, 6 )';
end

x = {y1,y2,y3,y4, y5};

sColor = AntarcticSeason.getSeasonalColor();

vYLabels1 = { 'SBI strength', 'SBI strength', 'SBI thickness', 'SBI thickness', 'SBI'};
vYLabels2 = { 'mean(C)', 'median(C)', 'mean(m)', 'median(m)', 'Num'};
fig=figure;
for i=1:5
    subplot(3,2,i)
    bh = bar(x{i});
    myLim = adjustPlotLim(x{i}(:), 0.1);

    if i<4 
        xticks( xTickValues );
        xticklabels( xTickNoneLabels );
    else
        xticks( xTickValues );
        xticklabels( xTickLabels );
        xtickangle(45);
    end

    ylim( myLim );      


    bh(1).FaceColor = sColor.summer;   %summer
    bh(2).FaceColor = sColor.fall;     %fall
    bh(3).FaceColor = sColor.winter;   %winter
    bh(4).FaceColor = sColor.spring;   %winter

    ylabel( {vYLabels1{i}, vYLabels2{i}} );
    if( i==1 )
        legend('Summer', 'Fall',  'Winter', 'Spring' );
        title( ['SBI Seasonal Trend by ', interpMethod, ' interpolation from ',  num2str(begYear), ' to ', num2str(endYear)] )
    end

    %xlim([0,m]);
    ax = gca;
    ax.FontSize = 15;
end

filename = fullfile('../data/processed', ['all-stations-SBI-seasonal-tread-bar-chart-', num2str(begYear), '-', num2str(endYear), '-', interpMethod,'.png']);
set(fig, 'PaperUnits', 'inches');
set(fig, 'PaperPosition', [0 0 15 8]); % [left, bottom, width, height]
print( fig, filename, '-dpng', '-r300');

end

