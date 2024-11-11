function  seasonalTrend  = calSbiSeasonalTrend(tab0, stationName)
%input:
%tab0: m x 19
%      [Year,seasonCode, T0(mean,std, median), T200(mean,std, median), T500(mean,std, median), ...
%       SBI strength(mean,std, median), SBI thickness(mean,std, median), #SBIs, #NonSBIs]
%output:
% monthlyTrend.name
% monthlyTrend.tab: 4 x 7, [seasonCode, Trend for [StrengthMean, strengthMedian, thicknessMean, thicknessMedian, #SBIs, #NonSBIs]];

seasonalTrend.station = stationName;
seasonalTrend.tab = nan(4, 7);
disp( stationName )
disp('    seasonal trend of:   StrengthMean, strengthMedian, thicknessMean, thicknessMedian, #SBIs, #NonSBIs');


tab1 = UtilFuncs.remove_nan(tab0);
for seasonCode=1:4
    I =  (tab1(:, 2) == seasonCode );

    %only for [SBI strength mean, SBI strength median, SBI thickness mean, SBI thickness median, #SBIs, #NonSBIs]
    tab2 = [tab1(I, 12), tab1(I, 14), tab1(I, 15), tab1(I, 17), tab1(I, 18), tab1(I, 19)]; 

    trendResults = nan(1, 6);
    for i=1:6
        [LT] = calTrendDecompSeasonal( tab2(:,i));

        %since we have one sample point for each month and our time unit
        %is month, trend refers to monthly trend. Therefore fs=1
        fs=1; 
        tmp = chadGreeneTrend(LT, fs);
        trendResults(i) = tmp;
    end
    
    fprintf('seasonCode=%d, %11.7f,%11.7f,%13.7f,%13.7f,%13.7f,%13.7f\n', ...
        seasonCode, trendResults(1), trendResults(2), trendResults(3), trendResults(4), trendResults(5), trendResults(6) );

    seasonalTrend.tab(seasonCode, : ) = [seasonCode, trendResults];
end
