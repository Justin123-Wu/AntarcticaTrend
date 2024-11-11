function plotTempSeasonalTrendBarChart( vSeasonalTrend, begYear, endYear, interpMethod )
%vSeasonalTrend: numStations x 1 cell, each cell has
%                seasonalTrend.name
%                seasonalTrend.tab: 4 x 7, [seasonCode,T0MeanTread(C),T0MedianTread(C),T200MeanTread(C),T200MedianTread(C),T500MeanTread(C),T500MedianTread(C)];

%https://www.mathworks.com/help/matlab/ref/bar.html#bug9u7m-1

numStations = numel(vSeasonalTrend);

xTickValues = (1:numStations);
xTickLabels = cell(numStations,1);
xTickNoneLabels = cell(numStations,1);

y1 = zeros(numStations, 4);  %each station's T0Mean for four seasons
y2 = zeros(numStations, 4);  %each station's T0Median for four seasons
y3 = zeros(numStations, 4);  %each station's T200Mean for four seasons
y4 = zeros(numStations, 4);  %each station's T200Median for four seasons
y5 = zeros(numStations, 4);  %each station's T500Mean for four seasons
y6 = zeros(numStations, 4);  %each station's T500Median for four seasons

for i=1:numStations
    xTickLabels{i} = vSeasonalTrend{i}.station;
    xTickNoneLabels{i} = '';
    y1(i, :) = vSeasonalTrend{i}.tab( :, 2 )';
    y2(i, :) = vSeasonalTrend{i}.tab( :, 3 )';
    y3(i, :) = vSeasonalTrend{i}.tab( :, 4 )';
    y4(i, :) = vSeasonalTrend{i}.tab( :, 5 )';
    y5(i, :) = vSeasonalTrend{i}.tab( :, 6 )';
    y6(i, :) = vSeasonalTrend{i}.tab( :, 7 )';
end

x = {y1,y2,y3,y4,y5,y6};

vYLabels = { 'T0 mean(C)', 'T0 median(C)', 'T200-T0 mean(C)', 'T200-T0 median(C)', 'T500-T0 mean(C)', 'T500-T0 median(C)'};
fig=figure;
for i=1:6
    subplot(3,2,i)
    bh = bar(x{i});
    myLim = adjustPlotLim(x{i}(:), 0.1);

    ymin = min( x{i}(:) );
    ymax = max( x{i}(:) );
    d = (ymax - ymin)*0.1;
    ymin = ymin - d; 
    ymax = ymax + d;
    
    if i<5
        xticks( xTickValues );
        xticklabels( xTickNoneLabels );
    else
        xticks( xTickValues );
        xticklabels( xTickLabels );
        xtickangle(45);
    end
    bh(1).FaceColor = [1 0 0];         %summer
    bh(2).FaceColor = [0 0 1];   %fall
    bh(3).FaceColor = [0 191/255, 1];  %winter
    bh(4).FaceColor = [0 1 128/255];   %spring

    ylabel( vYLabels{i} );
    if( i==1 )
        legend('Summer', 'Fall',  'Winter', 'Spring' );
        title( ['Temperature Seasonal Trend by ',  interpMethod, ' interpolation from ', num2str(begYear), ' to ', num2str(endYear)] )
    end

    ylim( myLim );      
    %ylim([-0.2, 0.27]);

    ax = gca;
    ax.FontSize = 15;
end

fname = fullfile('../data/processed', ['all-stations-Temp-seasonal-tread-bar-chart-', num2str(begYear), '-', num2str(endYear), '-', interpMethod, '.png']);
disp(fname);
set(fig, 'PaperUnits', 'inches');
set(fig, 'PaperPosition', [0 0 15 8]); % [left, bottom, width, height]
print( fig, fname, '-dpng', '-r300');


end

