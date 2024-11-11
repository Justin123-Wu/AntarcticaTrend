classdef ComputeStatisticsSeasonal
    properties
        station=[];
        begYear=0;
        endYear=0;
    end

    methods
        function  obj= ComputeStatisticsSeasonal( obsStation, begYY, endYY )
            obj.station = obsStation;
            obj.begYear = begYY;
            obj.endYear = endYY;
        end

        function [outTab] = calAndSaveAll(obj)
            nTotalSeasons = (obj.endYear-obj.begYear+1)*4;

            %outTab: [Year,seasonCode, T0(mean,std, median), T200(mean,std, median), T500(mean,std, median), ...
            %       SBI strength(mean,std, median), SBI thickness(mean,std, median), #SBIs, #NonSBIs]
            outTab = nan( nTotalSeasons,  2+5*3+2);
            cnt = 0;
            monthlyProfileDir = obj.station.outputDir;
            for yy=obj.begYear:obj.endYear
                for seasonCode=1:4
                    seasonalStatisticsRow = ComputeStatisticsSeasonal.calSeasonalStatistics(monthlyProfileDir, yy, seasonCode, obj.station.interpMethod);
                    if isempty(seasonalStatisticsRow)
                        continue;
                    end

                    cnt = cnt + 1;
                    outTab(cnt,:) = [yy, seasonCode, seasonalStatisticsRow];
                end
            end
            outTab( (cnt+1):end, :)=[];

            headerVars = {'Year','seasonCode(1-summer,2-fall,3-winter,4-spring)', ...
                'T0Mean (C)', 'T0Std(C)', 'T0Median (C)', ...
                'T200Mean(C)', 'T200Std(C)', 'T200Median(C)', ...
                'T500Mean(C)', 'T500Sdt(C)', 'T500Median(C)', ...
                'SBIStrengthMean(C)', 'SBIStrengthStd(C)', 'SBIStrengthMedian(C)', ...
                'SBIThicknessMean(m)', 'SBIThicknessSdt(m)', 'SBIThicknessMedian(m)', ...
                '# SBIs', '# non SBIs'};

            T = array2table(outTab,'VariableNames',headerVars);

            outputFilePath = obj.station.getSeasonalStatisticsFilePath(obj.begYear, obj.endYear);
            writetable(T, outputFilePath);
        end
    end %methods

    methods (Static)
        function [outRow] = calSeasonalStatistics(dataDir, year, seasonCode,  interpMethod)
            %------------------------------------------------------------
            % calculate the montly statistics
            %input:
            % monthlyProfileFileName
            %ouput:
            % outRow: n x 17
            % [T0(mean, std, median), T200-T0(mean, std, median), T500-T0(mean, std,median), ...
            %  sbiStrength(mean, std, median],sbiThickness(mean, std, median], [# SBIs, # nonSBIs]
            %
            % ref: doc/Approaches.pptx: seasonal Statistics Slides
            %------------------------------------------------------------
            outRow=[];
            
            %get all the monthly profile by given year and season code
            vFilepath = AntarcticSeason.getSeasonalProfileFilePaths(dataDir, year, seasonCode, interpMethod);
            nFiles = numel(vFilepath);

            x_T0  = [];    %T0
            x_T200  = [];  %T200-T0
            x_T500  = [];  %T500-T0
            x_sbiFlags  = [];     %[# SBIs, # nonSBIs]
            x_sbiStrength  = [];  %sbiStrength(mean, std, median]
            x_sbiThickness  = [];  %sbiThickness(mean, std, median]

            for i=1:nFiles
                monthlyProfileFileName = vFilepath{i};
                if ~exist(monthlyProfileFileName, 'file')
                    continue;
                end

                tab =  readmatrix(monthlyProfileFileName, 'NumHeaderLines', 1);
                %---------------------------------------------------
                %tab: N x 32, [height, day1, ..., day31]
                %(see doc/Appraches.ppt -> slide Monthly Profile
                %---------------------------------------------------

                [nRows, nCols] = size(tab);
                assert( nCols==32, 'the monthly profile tab should be 32 cols!');
                assert(nRows>8, "the monthly profile tab should be more than 6 rows!");

                %concat three months data into to corresponding vectors
                x_T0  = [x_T0, tab(1, 2:32)];                    %concat T0 from current month's data
                x_T200  = [x_T200, tab(nRows-6, 2:32)];          %concat T200 from current month's data
                x_T500  = [x_T500, tab(nRows-5, 2:32)];          %concat T500 from current month's data

                x_sbiFlags  = [x_sbiFlags, tab(nRows-4, 2:32)];           %concat sbiFlags from current month's data
                x_sbiStrength  = [x_sbiStrength, tab(nRows-3, 2:32)];     %concat sbiStrength from current month's data
                x_sbiThickness  = [x_sbiThickness, tab(nRows-2, 2:32)];   %concat sbiThickness from current month's data
                %tab(nRows-1, 2:32),  SBI inversion point Temperature for debugging
                %tab(nRows, 2:32),   SBI inversion point height for debugging

            end
            if isempty(x_T0)
                return;
            end

            %
            %now  x_T0,  x_T200, x_T500, x_sbiFlags, x_sbiStrength,x_sbiThickness
            %are 1 x n  arrays, where n is # of days in the season
            %

            %next we calculate the mean, std, and median values
            T0_stats  = UtilFuncs.calMeanStdMedian(x_T0);      %T0: (mean, std, median)
            T200_stats  = UtilFuncs.calMeanStdMedian(x_T200);  %T200-T0: (mean, std, median)
            T500_stats  = UtilFuncs.calMeanStdMedian(x_T500);  %T500-T0: (mean, std, median)
            sbiStrength_stats  = UtilFuncs.calMeanStdMedian(x_sbiStrength);  %sbiStrength(mean, std, median]
            sbiThickness_stats  = UtilFuncs.calMeanStdMedian(x_sbiThickness);   %sbiThickness(mean, std, median]
            [numSBIs, numNonSBIs]  = UtilFuncs.calSbiNonSbiNum(x_sbiFlags);      %[# SBIs, # nonSBIs]

            %finally we put them together to ultimately return an output
            %vector
            outRow = [T0_stats, T200_stats, T500_stats, sbiStrength_stats, sbiThickness_stats, numSBIs, numNonSBIs];
        end %function 

    end %methods (Static)
end %classdef ComputeStatisticsSeasonal
