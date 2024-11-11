function test_plotMonthlyProfile
%--------------------------------------------------------------------------
%visual monthly temperature profile given a station name, year and month
% input:
%         data/processed/stationName/yyyy-mm-profile.csv
% output:
%         the daily plots of the height vs. temperature profile including
%         SBI info
%
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
dataDir = fullfile(pwd, '..', 'data');                %dataDir='./Antarctica/src/../data';
vStations = StationArray(dataDir, interpMethod);      %create a StationArray object to load all station info

%which station and which year/month do you want to plot?
stationIdx = 1; %
station = vStations.getStation(stationIdx);
station.disp();
yy = 2010;
filterFlag = 0; %filterFlag=1 only plot SBI, 0 only non-SBI, -1 only unknown, otherwise plot all SBI cases
islog10Y = true;
for mm = 12:12
    plotMonthlyProfile( station, yy, mm, filterFlag, islog10Y);
end
end



