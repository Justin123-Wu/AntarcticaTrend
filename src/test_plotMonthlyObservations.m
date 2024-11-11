function test_plotMonthlyObservations
%--------------------------------------------------------------------------
%visualize monthly observation profile parsed from the raw data file
% input:
%         station, year, month
% output:
%         variety of plots
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
vStations = StationArray(dataDir, interpMethod);      %create a StationArray object to load all station info

%which station and which year, month?
stationIdx = 1;
station = vStations.getStation(stationIdx);
station.disp();

yy = 2020;  
isInterp = true;
%      'linear'   - (default) linear interpolation
%      'nearest'  - nearest neighbor interpolation
%      'next'     - next neighbor interpolation
%      'previous' - previous neighbor interpolation
%      'spline'   - piecewise cubic spline interpolation (SPLINE)
%      'pchip'    - shape-preserving piecewise cubic interpolation
%      'cubic'    - cubic convolution interpolation for uniformly-spaced

for mm = 1:1
    for dd=1:2:30
        mObs = ObservationMonthly( station,yy, mm );
        %mObs.plot_temp_vs_pressure( yy, mm, dd )
        mObs.plot_temp_vs_height( yy, mm, dd, isInterp, interpMethod )
        %mObs.plot_gph_vs_temp( yy, mm, dd );
        %mObs.plot_temp_vs_dpdp( yy, mm, dd );
    end
end
end



