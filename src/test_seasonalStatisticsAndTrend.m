function test_seasonalStatisticsAndTrend
%--------------------------------------------------------------------------
%compute seasonal temperature and SBI statistics and trend from monthly profile
% inputs: 
%         data/processed/stationName/2000-01-profile.csv
%           ..
%         data/processed/stationName/2024-12-profile.csv
% output:
%         data/processed/stationName/SeasonalStatistics-2000-2024.csv
%         Temperature Seasonal TrendBar Chart  
%         SBI Seasonal Trend BarChart 
%         Temperature Seasonal Statistics Plot (optional)
%         SBI Seasonal Statistics Plot (optional)
%--------------------------------------------------------------------------
close all

addpath('./coreAlg/', './plots/');

interpMethod = 'linear';
%      'linear'   - (default) linear interpolation
%      'nearest'  - nearest neighbor interpolation
%      'next'     - next neighbor interpolation
%      'previous' - previous neighbor interpolation
%      'spline'   - piecewise cubic spline interpolation (SPLINE)
%      'pchip'    - shape-preserving piecewise cubic interpolation
%      'cubic'    - cubic convolution interpolation for uniformly-spaced

dataDir = fullfile(pwd, '..', 'data');  %dataDir='./Antarctica/src/../data';
objStations = StationArray(dataDir, interpMethod);      %create a StationArray object to load all station info
%nStations = 1; 
nStations = objStations.nTotStations;

%the parameters for each station
begYear=2000;
endYear=2023;

isRecalculate = true;
plotSeasonalStatistics = 1;

vSbiSeasonalTrend = cell(nStations,1);
vTempSeasonalTrend = cell(nStations,1);
for i=1:nStations
    station = objStations.getStation(i);
    if isRecalculate
        obj = ComputeStatisticsSeasonal(station, begYear, endYear );
        outTab = obj.calAndSaveAll();
    else
        filePath = station.getSeasonalStatisticsFilePath(begYear, endYear);
        outTab =  readmatrix(filePath, 'NumHeaderLines', 1);
    end

    vSbiSeasonalTrend{i}  = calSbiSeasonalTrend(outTab, station.name);
    vTempSeasonalTrend{i} = calTempSeasonalTrend(outTab, station.name);
    if plotSeasonalStatistics
        plotSbiSeasonalStatistics2(outTab, station, begYear, endYear, vSbiSeasonalTrend{i}.tab);
        plotTempSeasonalStatistics2(outTab, station, begYear, endYear,  vTempSeasonalTrend{i}.tab );
    end
end

if nStations==objStations.nTotStations
    plotTempSeasonalTrendBarChart( vTempSeasonalTrend, begYear, endYear, interpMethod );
    plotSbiSeasonalTrendBarChart( vSbiSeasonalTrend, begYear, endYear, interpMethod );
end

end
