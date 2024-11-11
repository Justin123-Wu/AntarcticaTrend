function test_creatMonthlyProfile
close all

addpath('./coreAlg/', './plots/');

vInterpMethod = {'linear', 'spline'};
for jj=1:2
    interpMethod = vInterpMethod{jj};
    %      'linear'   - (default) linear interpolation
    %      'nearest'  - nearest neighbor interpolation
    %      'next'     - next neighbor interpolation
    %      'previous' - previous neighbor interpolation
    %      'spline'   - piecewise cubic spline interpolation (SPLINE)
    %      'pchip'    - shape-preserving piecewise cubic interpolation
    %      'cubic'    - cubic convolution interpolation for uniformly-spaced

    dataDir = fullfile(pwd, '..', 'data');  %dataDir='./Antarctica/src/../data';
    vStations = StationArray(dataDir, interpMethod);

    %nStations = 1;
    nStations = vStations.nTotStations;

    %the parameters for each station
    fid = fopen(['./', interpMethod, '-rawInfo.txt'], 'w');
    numOfObsToRead = inf;  % inf - to read all observations
    for i=1:nStations
        station = vStations.getStation(i);
        station.disp();

        x = ParseRawFile(station, numOfObsToRead);

        %x.dumpObservationResults();
        %----------------------------------------------------------
        % output data/processed/stattionName/yyyy-mm-observation.csv
        %----------------------------------------------------------

        x.calculateAndSaveAllMonthlyProfiles();
        %----------------------------------------------------------------------
        % output data/processed/stattionName/yyyy-mm-profile.csv,
        % (see doc/Approches.ppx ->Monthly Profile slide for details)
        % each file has the following format.
        % height (m),day1, ..., day31      <=== head
        % h0, ...                          <=== 1st temperature profile line
        % h0+50, ...
        % h0+100, ...
        % ...
        % h0+10000, ....                   <=== last temperature profile line
        % T200-T0, ...                     <=== T200-T0
        % T500-T0, ...                     <=== T500-T0
        % HasSBI, ...                      <=== has SBI
        % SBI Strength, ...                <=== SBI strength
        % SBI Thickness, ...               <=== SBI thickness
        % SBI inversion point temperature   <=== SBI strength
        % SBI inversion point height       <=== SBI thickness (last row)
        %----------------------------------------------------------------------

        x.dumpInfo( fid );
    end %for i
    fclose(fid);
end %for jj
end
