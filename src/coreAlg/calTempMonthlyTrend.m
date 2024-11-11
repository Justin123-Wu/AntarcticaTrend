function  [monthlyTrend]  = calTempMonthlyTrend(tab0, stationName)
%input:
%tab0: m x 19
%      [Year,month, T0(mean,std, median), T200(mean,std, median), T500(mean,std, median), ...
%       SBI strength(mean,std, median), SBI thickness(mean,std, median), #SBIs, #NonSBIs]
%output:
% monthlyTrend.name
% monthlyTrend.tab: 12 x 7, [month, T0-mean-trend, T0-median-trend, T200-mean-trend, T200-median--trend, T500-mean-trend, T500-median-trend];

monthlyTrend.station = stationName;
monthlyTrend.tab = nan(12, 7);
disp( stationName )
disp('     trend of   T0Mean, T0Median, T200Mean, T200Median, T500Mean, T500Median');


tab1 = UtilFuncs.remove_nan(tab0);
for mm = 1:12
    
    I =  (tab1(:, 2) == mm );

    %only for [T0(mean, median), T200(mean, median), T500(mean, median)]
    %tab2: n x 6
    tab2 = [tab1(I, 3), tab1(I, 5), tab1(I, 6), tab1(I, 8), tab1(I, 9), tab1(I, 11)]; 
    
    trendResults = nan(1, 6);
    for i=1:6
        [LT] = calTrendDecompMonthly( tab2(:,i));

        %since we have one sample point for each month and our time unit
        %is month, so trend refers to monthly trend. Therefore fs=1
        fs=1; 
        tmp = chadGreeneTrend(LT, fs);
        trendResults(i) = tmp;
    end

    fprintf('mm=%d, %11.7f,%11.7f,%13.7f,%13.7f,%13.7f,%13.7f\n', ...
        mm, trendResults(1), trendResults(2), trendResults(3), trendResults(4), trendResults(5), trendResults(6) );

    monthlyTrend.tab(mm, : ) = [mm, trendResults];
end
end


