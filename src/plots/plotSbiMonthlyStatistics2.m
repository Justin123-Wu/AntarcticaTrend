function plotSbiMonthlyStatistics2(tab0, station, seasonCode, begYear, endYear, trendSlope)
%input:
%tab0: m x 19
%     [Year,month, T0(mean,std, median), T200(mean,std, median), T500(mean,std, median), ...
%      SBI strength(mean,std, median), SBI thickness(mean,std, median), #SBIs, #NonSBIs]
%trendSlope: [month, SBIStrengthTrend(mean, media), SBIthicknessTrend(mean, media), TrendForSBIs, TrendForNonSBIs]

fsz = 14;
vMonths = AntarcticSeason.getMonthsFromSeasonCode(seasonCode);

fig = figure;
for j=1:3
    curMonth = vMonths(j);
    subTitle1 = [num2str(trendSlope(curMonth,6), 'sbi s=%.3f'),  num2str(trendSlope(curMonth,7), ', non-sbi s=%.3f')] ;
    subTitle2 = [num2str(trendSlope(curMonth,2), 'mean s=%.3f'), num2str(trendSlope(curMonth,3), ', median s=%.3f')]  ;
    subTitle3 = [num2str(trendSlope(curMonth,4), 'mean s=%.3f'), num2str(trendSlope(curMonth,5), ', median s=%.3f')]  ;
    
    I =  ( tab0(:, 2) == curMonth );
    tab = tab0(I,:);
    yy = tab(:,1);

    idx = j;
    subplot(3,3,idx)
    grid on
    hold on;
    box on;
    LT1 = calTrendDecompMonthly( tab(:, 18) );
    LT2 = calTrendDecompMonthly( tab(:, 19) );   
    plot( yy, tab(:, 18), '-+',  'color', [0, 0, 1] );   %# of SBI
    plot( yy, tab(:, 19), '--o', 'color', [0, 1,  0] );  %# of NON-SBI
    plot( yy, LT1, '--x', 'color', [0, 0,  1] );
    plot( yy, LT2, '--s', 'color', [0, 1,  0] );
    
    ylabel( "SBI, NON-SBI Number");
    xlim([begYear, endYear]);
    if j==1
        legend( 'Num SBI','Num non-SBI', 'Num SBI LT','Num non-SBI LT');
        title( [station.name, ', ', station.interpMethod, ', month=', num2str(curMonth)] );
    else
        title( ['month=', num2str(curMonth)] );
    end
    subtitle(subTitle1 );
    set(gca,'xticklabel',{[]}); %do not show x-tick label

    ax = gca;
    ax.FontSize = fsz;

    idx = idx+3;
    subplot(3,3,idx)
    hold on;
    grid on;
    box on;

    LT1 = calTrendDecompMonthly( tab(:, 12) );
    LT2 = calTrendDecompMonthly( tab(:, 14) );      
    ha = plot( yy, tab(:,12), '-+', 'color',  [0, 0, 1] ); %SBI strength mean
    hb = plot( yy, tab(:,14), '--o', 'color', [0, 1, 0]); %SBI strength median
    plot( yy, LT1, '--x', 'color', [0, 0,  1] );
    plot( yy, LT2, '--s', 'color', [0, 1,  0] );
    
    ylabel( "SBI Strength (C)");
    xlim([begYear, endYear]);
    if j==1   
        legend('mean', 'median', 'mean LT', 'median LT');
    end   
    subtitle(subTitle2 );
    set(gca,'xticklabel',{[]}); %do not show x-tick label

%    legend( [ha,hb], ['SBI Strength Mean Trend:', num2str(trendResults(2))], ...
%        ['SBI Strength median Trend: ',num2str(trendResults(3))] );
    ax = gca;
    ax.FontSize = fsz;


    idx = idx+3;
    subplot(3,3,idx)
    grid on;
    hold on;
    box on;

    LT1 = calTrendDecompMonthly( tab(:, 15) );
    LT2 = calTrendDecompMonthly( tab(:, 17) );      
    hc = plot( yy, tab(:,15), '-+', 'color', [0, 0, 1] ); %SBI thickness mean
    hd = plot( yy, tab(:,17), '--o','color', [0, 1, 0]); %SBI thickness median
    plot( yy, LT1, '--x', 'color', [0, 0,  1] );
    plot( yy, LT2, '--s', 'color', [0, 1,  0] );
    ylabel( "SBI rhickness (m)");  
%    legend( [hc,hd], ['SBI Thickness mean trend:', num2str(trendResults(5))], ...
%        ['SBI Thickness median trend:', num2str(trendResults(6))]);
    xlabel( 'year' )
    xlim([begYear, endYear]);  
    subtitle(subTitle3 );
    
    ax = gca;
    ax.FontSize = fsz;
end
filename = station.getMonthlySbiStatisticsPngFilePath(begYear, endYear, seasonCode);
set(fig, 'PaperUnits', 'inches');
set(fig, 'PaperPosition', [0 0 15, 8]);  % [left, bottom, width, height]
print( fig, filename, '-dpng', '-r300'); % 300 DPI resolution

end


