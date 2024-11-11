function plotTempMonthlyStatistics2(tab0, station, seasonCode, begYear, endYear, trendSlope)
%input:
%tab0: m x 19
%     [Year,month, T0(mean,std, median), T200(mean,std, median), T500(mean,std, median), ...
%      SBI strength(mean,std, median), SBI thickness(mean,std, median), #SBIs, #NonSBIs]
%trendResults: [month, SBIStrengthTred(mean, media), SBIthicknessTred(mean, media), TrendForSBIs, TrendForNonSBIs]

fsz = 13;
vMonths = AntarcticSeason.getMonthsFromSeasonCode(seasonCode);

fig=figure;
for j=1:3
    curMonth = vMonths(j);
    subTitle1 = [num2str(trendSlope(curMonth,2), 'mean s=%.3f'), num2str(trendSlope(curMonth,3), ', median s=%.3f')]  ;
    subTitle2 = [num2str(trendSlope(curMonth,4), 'mean s=%.3f'), num2str(trendSlope(curMonth,5), ', median s=%.3f')]  ;
    subTitle3 = [num2str(trendSlope(curMonth,6), 'mean s=%.3f'),  num2str(trendSlope(curMonth,7),', median s=%.3f')] ;
    
    I =  ( tab0(:, 2) == curMonth );
    tab = tab0(I,:);

    yy = tab(:,1);
    
    idx = j;
    subplot(3,3,idx)
    grid on;
    hold on;
    box on;

    LT1 = calTrendDecompMonthly( tab(:, 3) );
    LT2 = calTrendDecompMonthly( tab(:, 5) );
    plot( yy, tab(:, 3), '-+',  'color', [0, 0, 1] );
    plot( yy, tab(:, 5), '-o', 'color', [0, 1,  0] );
    plot( yy, LT1, '--x', 'color', [0, 0,  1] );
    plot( yy, LT2, '--s', 'color', [0, 1,  0] );
    ylabel( "T0 (C)");
    xlim([begYear, endYear]);
    if j==1
        legend( 'mean', 'median', 'mean trendDecomp', 'median trendDecomp' );
    end       
    
    if j==1
        title( [station.name, ', ', station.interpMethod, ', month=', num2str(curMonth)] );
    else
        title( ['month=', num2str(curMonth)] );
    end
    subtitle(subTitle1 );
    set(gca,'xticklabel',{[]}); %do not show x-tick label

    ax = gca;
    ax.FontSize = fsz;

    idx = idx + 3;
    subplot(3,3,idx)
    hold on;
    grid on;
    box on;

    LT1 = calTrendDecompMonthly( tab(:, 6) );
    LT2 = calTrendDecompMonthly( tab(:, 8) );   
    ha = plot( yy, tab(:,6), '-+', 'color', [0, 0, 255/255] ); %SBI strength mean
    hb = plot( yy, tab(:,8), '-o', 'color', [0, 1,  0]); %SBI strength median
    plot( yy, LT1, '--x', 'color', [0, 0,  1] );
    plot( yy, LT2, '--s', 'color', [0, 1,  0] );
   
    ylabel( "T200-T0(C)");
    xlim([begYear, endYear]);   
    subtitle(subTitle2 );
    set(gca,'xticklabel',{[]}); %do not show x-tick label
    
    ax = gca;
    ax.FontSize = fsz;

    idx = idx + 3;
    subplot(3,3,idx)
    grid on;
    hold on;
    box on;

    LT1 = calTrendDecompMonthly( tab(:, 9) );
    LT2 = calTrendDecompMonthly( tab(:, 11) );   
    hc = plot( yy, tab(:,9), '-+', 'color', [0, 0, 255/255] ); %SBI thickness mean
    hd = plot( yy, tab(:,11), '-o','color', [0, 1,  0]); %SBI thickness median
    plot( yy, LT1, '--x', 'color', [0, 0,  1] );
    plot( yy, LT2, '--s', 'color', [0, 1,  0] );
    
    ylabel( "T500-T0(C)");
    xlim([begYear, endYear]);   
    xlabel( 'year' )
    subtitle(subTitle3 );
    
    ax = gca;
    ax.FontSize = fsz;   
end
filename = station.getMonthlyTempStatisticsPngFilePath(begYear,endYear, seasonCode);
disp(filename);
set(fig, 'PaperUnits', 'inches');
set(fig, 'PaperPosition', [0 0 15, 8]);  % [left, bottom, width, height]
print( fig, filename, '-dpng', '-r300'); % 300 DPI resolution

end


