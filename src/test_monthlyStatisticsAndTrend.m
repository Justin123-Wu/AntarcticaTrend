function test_monthlyStatisticsAndTrend
%--------------------------------------------------------------------------
%compute monthly temperature and SBI statistics and trend from monthly profile
% inputs: 
%         data/processed/stationName/2000-01-profile.csv
%           ..
%         data/processed/stationName/2024-12-profile.csv
% output:
%         data/processed/stationName/monthlyStatistics-2000-2024.csv
%         TemperatureMonthlyStatisticsPlot (optional)
%         SbiMonthlyStatisticsPlot (optional)
%         TemperatureMonthlyTrendBarChart  
%         SBIMonthlyTrendBarChart 
%--------------------------------------------------------------------------
close all;
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

nStations = 1; 
%nStations = objStations.nTotStations;

%the parameters for each station
begYear=2000;
endYear=2023;

isRecalculate = false;
plotMonthlyStatistics = 1;
vSbiMonthlyTrend = cell(nStations,1);
vTempMonthlyTrend = cell(nStations,1);
for i=1:nStations
    station = objStations.getStation(i);
    if isRecalculate
        obj = ComputeStatisticsMonthly(station, begYear, endYear );
        outTab = obj.calAndSaveAll();
    else
        outputFilename = station.getMonthlyStatisticsFilePath(begYear, endYear);
        outTab = readmatrix(outputFilename, 'NumHeaderLines', 1);
    end

    vSbiMonthlyTrend{i}  = calSbiMonthlyTrend(outTab, station.name);
    vTempMonthlyTrend{i} = calTempMonthlyTrend(outTab, station.name);

    if plotMonthlyStatistics
        plotSbiMonthlyStatistics2(outTab, station, 1,  begYear, endYear, vSbiMonthlyTrend{i}.tab  );
        plotSbiMonthlyStatistics2(outTab, station, 2,  begYear, endYear, vSbiMonthlyTrend{i}.tab  );
        plotSbiMonthlyStatistics2(outTab, station, 3,  begYear, endYear, vSbiMonthlyTrend{i}.tab  );
        plotSbiMonthlyStatistics2(outTab, station, 4,  begYear, endYear, vSbiMonthlyTrend{i}.tab  );

        plotTempMonthlyStatistics2(outTab, station, 1, begYear, endYear, vTempMonthlyTrend{i}.tab  );
        plotTempMonthlyStatistics2(outTab, station, 2, begYear, endYear, vTempMonthlyTrend{i}.tab  );
        plotTempMonthlyStatistics2(outTab, station, 3, begYear, endYear, vTempMonthlyTrend{i}.tab  );
        plotTempMonthlyStatistics2(outTab, station, 4,  begYear, endYear,vTempMonthlyTrend{i}.tab  );
    end

end

if nStations == objStations.nTotStations
    plotTempMonthlyTrendBarChart( vTempMonthlyTrend,begYear, endYear, interpMethod );
    plotSbiMonthlyTrendBarChart( vSbiMonthlyTrend, begYear, endYear, interpMethod );
end
end

