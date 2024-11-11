function plotSbiSeasonalStatistics2(tab0, station, begYear, endYear, trendSlope)
%input:
%tab0: m x 19
%     [Year,seasonCode, T0(mean,std, median), T200(mean,std, median), T500(mean,std, median), ...
%      SBI strength(mean,std, median), SBI thickness(mean,std, median), #SBIs, #NonSBIs]
%trendSlope: 4 x 7, [seasonCode, SBIStrengthTred(mean, media), SBIthicknessTred(mean, media), TrendForSBIs, TrendForNonSBIs]
fsz=12;

fig=figure;
for j=1:4
    curSeasonCode = j;
    subTitle1 = [num2str(trendSlope(j,6), 'sbi s=%.3f'),  num2str(trendSlope(j,7), ', non-sbi s=%.3f')] ;
    subTitle2 = [num2str(trendSlope(j,2), 'mean s=%.3f'), num2str(trendSlope(j,3), ', median s=%.3f')]  ;
    subTitle3 = [num2str(trendSlope(j,4), 'mean s=%.3f'), num2str(trendSlope(j,5), ', median s=%.3f')]  ;

    I =  ( tab0(:, 2) == curSeasonCode );
    tab = tab0(I,:);
    yy = tab(:,1);

    %--------------------
    idx = j;
    subplot(3,4,idx)   
    grid on;
    hold on;
    box on;
    LT1 = calTrendDecompSeasonal( tab(:, 18) );
    LT2 = calTrendDecompSeasonal( tab(:, 19) );   
    plot( yy, tab(:, 18), '-+',  'color', [0, 0, 1] );   %# of SBI
    plot( yy, tab(:, 19), '-o', 'color', [0, 1, 0] );    %# of NON-SBI
    plot( yy, LT1, '--x',  'color', [0, 0, 1] ); 
    plot( yy, LT2, '--s', 'color', [0, 1, 0] );  
    
    ylabel( "SBI, NON-SBI Num");
    xlim([begYear, endYear]);
    if j==1
        legend( 'Num SBI','Num non-SBI', 'Num SBI LT','Num non-SBI LT');
        title( [station.name, ', ', station.interpMethod, ' interp.,',  AntarcticSeason.getSeasonNameFromCode(curSeasonCode)] );
    else
        title( [AntarcticSeason.getSeasonNameFromCode(curSeasonCode) ] );
    end
    subtitle(subTitle1 );
    set(gca,'xticklabel',{[]}); %do not show x-tick label

    ax = gca;
    ax.FontSize = fsz;

    %--------------------
    idx = idx+4;
    subplot(3,4,idx)
    hold on;
    grid on;
    box on;

    LT1 = calTrendDecompSeasonal( tab(:, 12) );
    LT2 = calTrendDecompSeasonal( tab(:, 14) );   
    plot( yy, tab(:,12), '-+', 'color', [0, 0, 1]  ); %SBI strength mean
    plot( yy, tab(:,14), '-o', 'color',[0, 1, 0]); %SBI strength median
    plot( yy, LT1, '--x',  'color', [0, 0, 1] ); 
    plot( yy, LT2, '--s', 'color', [0, 1, 0] );  
    
    ylabel( "SBI Strength (C)");
    xlim([begYear, endYear]);
    if j==1   
        legend('mean', 'median', 'mean LT', 'median LT');
    end
    subtitle(subTitle2 );
    set(gca,'xticklabel',{[]}); %do not show x-tick label

    ax = gca;
    ax.FontSize = fsz;

    %--------------------
    idx = idx+4;
    subplot(3,4,idx)
    grid on;
    hold on;
    box on;

    LT1 = calTrendDecompSeasonal( tab(:, 15) );
    LT2 = calTrendDecompSeasonal( tab(:, 17) );
    plot( yy, tab(:,15), '-+', 'color', [0, 0, 1]  ); %SBI thickness mean
    plot( yy, tab(:,17), '-o','color', [0, 1, 0]);   %SBI thickness median
    plot( yy, LT1, '--x',  'color', [0, 0, 1] ); 
    plot( yy, LT2, '--s', 'color', [0, 1, 0] );  
    
    ylabel( "SBI thickness (m)");
    xlim([begYear, endYear]);
    xlabel( 'year' )
    if j==1
        legend( 'mean', 'median', 'mean LT', 'median LT');   
    end
    subtitle(subTitle3 );
    
    ax = gca;
    ax.FontSize = fsz;
end

filename = station.getSeasonalSbiStatisticsPngFilePath(begYear, endYear);
disp(filename);
set(fig, 'PaperUnits', 'inches');
set(fig, 'PaperPosition', [0 0 15, 8]);  % [left, bottom, width, height]
print( fig, filename, '-dpng', '-r300'); % 300 DPI resolution

end



