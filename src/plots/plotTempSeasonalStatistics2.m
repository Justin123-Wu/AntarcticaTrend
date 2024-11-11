function plotTempSeasonalStatistics2(tab0, station, begYear, endYear, trendSlope)
%input:
%tab0: m x 19
%     [Year,seasonCode, T0(mean,std, median), T200(mean,std, median), T500(mean,std, median), ...
%      SBI strength(mean,std, median), SBI thickness(mean,std, median), #SBIs, #NonSBIs]
%trendSlope:  4 x 7, [seasonCode, Trend of T0 (mean, median), Trend of T200(mean, median), Trend of T500(mean, median)];

fsz=14;

nPlotCols = 4;
fig=figure;
for j=1:nPlotCols
    curSeasonCode = j;
    subTitle1 = [num2str(trendSlope(j,2), 'mean s=%.3f'), num2str(trendSlope(j,3), ', median s=%.3f')]  ;
    subTitle2 = [num2str(trendSlope(j,4), 'mean s=%.3f'), num2str(trendSlope(j,5), ', median s=%.3f')]  ;
    subTitle3 = [num2str(trendSlope(j,6), 'mean s=%.3f'),  num2str(trendSlope(j,7),', median s=%.3f')] ;

    I =  ( tab0(:, 2) == curSeasonCode );
    tab = tab0(I,:);
    yy = tab(:,1);

    idx = j;
    subplot(3,nPlotCols,idx)
    grid on;
    hold on;
    box on;
    LT1 = calTrendDecompSeasonal( tab(:, 3) );
    LT2 = calTrendDecompSeasonal( tab(:, 5) );
    
    plot( yy, tab(:, 3), '-+',  'color', [0, 0, 1] );  %T0-mean
    plot( yy, tab(:, 5), '-o', 'color', [0, 1, 0] );  %T0-median
    plot( yy, LT1, '--x',  'color', [0, 0, 1] ); 
    plot( yy, LT2, '--s', 'color', [0, 1, 0] );  
    ylabel( "T0");
    xlim([begYear, endYear]);

    if j==1
        legend({'mean', 'median', 'mean LT', 'median LT'}, 'Location','best')
    end
    if j==1
        title( [station.name, ', ', station.interpMethod,  ' interp., ', AntarcticSeason.getSeasonNameFromCode(curSeasonCode)] );
    else
        title( AntarcticSeason.getSeasonNameFromCode(curSeasonCode) );
    end
    subtitle(subTitle1 );
    set(gca,'xticklabel',{[]}); %do not show x-tick label

    ax = gca;
    ax.FontSize = fsz;
    
    %--------------------------
    idx = idx+nPlotCols;
    subplot(3,nPlotCols,idx)
    hold on;
    grid on;
    box on;
    LT1 = calTrendDecompSeasonal( tab(:, 6) );
    LT2 = calTrendDecompSeasonal( tab(:, 8) );   
    plot( yy, tab(:,6), '-+', 'color', [0, 0, 1] ); %T200-T0 mean
    plot( yy, tab(:,8), '-o', 'color', [0, 1, 0]); %T200-T0 median
    plot( yy, LT1, '--x',  'color', [0, 0, 1] ); 
    plot( yy, LT2, '--s', 'color', [0, 1, 0] );  
    ylabel( "T200-T0(C)");
    xlim([begYear, endYear]);   
    subtitle(subTitle2 );
    set(gca,'xticklabel',{[]}); %do not show x-tick label
    
    ax = gca;
    ax.FontSize = fsz;

    %--------------------------
    idx = idx+nPlotCols;
    subplot(3,nPlotCols,idx)
    grid on;
    hold on;
    box on;
    LT1 = calTrendDecompSeasonal( tab(:, 9) );
    LT2 = calTrendDecompSeasonal( tab(:, 11) );
    plot( yy, tab(:,9), '-+', 'color',  [0, 0, 1] ); %T500-T0 mean
    plot( yy, tab(:,11), '-o','color', [0, 1, 0]);  %T500-T0 median
    plot( yy, LT1, '--x',  'color', [0, 0, 1] ); 
    plot( yy, LT2, '--s', 'color', [0, 1, 0] );  
    
    ylabel( "T500-T0(C)");
    xlim([begYear, endYear]);
    xlabel( 'year' )
    subtitle(subTitle2 );
   
    ax = gca;
    ax.FontSize = fsz;
end
filename = station.getSeasonalTempStatisticsPngFilePath(begYear, endYear);
set(fig, 'PaperUnits', 'inches');
set(fig, 'PaperPosition', [0 0 15, 8]);  % [left, bottom, width, height]
print( fig, filename, '-dpng', '-r300'); % 300 DPI resolution

end




