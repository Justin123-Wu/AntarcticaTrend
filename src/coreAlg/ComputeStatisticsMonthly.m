classdef ComputeStatisticsMonthly
    properties
        station=[];
        begYear=0;
        endYear=0;
    end

    methods
        function  obj= ComputeStatisticsMonthly( obsStation, begYY, endYY )
            obj.station = obsStation;
            obj.begYear = begYY;
            obj.endYear = endYY;
        end

        function [outTab] = calAndSaveAll(obj)
            %outTab: [Year,month, T0(mean,std, median), T200(mean,std, median), T500(mean,std, median), ...
            %       SBI strength(mean,std, median), SBI thickness(mean,std, median), #SBIs, #NonSBIs]
            nTotalMonths = (obj.endYear-obj.begYear+1)*12;
            outTab = nan( nTotalMonths,  2+5*3+2);
            cnt = 0;
            for yy=obj.begYear:obj.endYear
                for mm=1:12
                    monthlyProfileFileName = obj.station.getMonthlyProfileFilePath(yy, mm);
                    monthlyStatisticsRow = ComputeStatisticsMonthly.calMonthlyStatistics(monthlyProfileFileName);
                    if isempty(monthlyStatisticsRow)
                        continue;
                    end

                    cnt = cnt + 1;
                    outTab(cnt,:) = [yy, mm, monthlyStatisticsRow];
                end
            end
            outTab( (cnt+1):end, :)=[];

            headerVars = {'Year','Month', ...
              'T0Mean (C)', 'T0Std(C)', 'T0Median (C)', ...
              'T200Mean(C)', 'T200Std(C)', 'T200Median(C)', ...
              'T500Mean(C)', 'T500Sdt(C)', 'T500Median(C)', ...               
              'SBIStrengthMean(C)', 'SBIStrengthStd(C)', 'SBIStrengthMedian(C)', ...
              'SBIThicknessMean(m)', 'SBIThicknessSdt(m)', 'SBIThicknessMedian(m)', ...
              '# SBIs', '# non SBIs'};
            
            T = array2table( single(outTab),'VariableNames',headerVars);

            outputFilename = obj.station.getMonthlyStatisticsFilePath(obj.begYear, obj.endYear);
            writetable(T, outputFilename);
        end

    end

    methods (Static)
        function [outRow] = calMonthlyStatistics(monthlyProfileFileName)
            %------------------------------------------------------------
            % calculate the montly statistics
            %input:
            % monthlyProfileFileName
            %ouput:
            % outRow: n x 17
            % [T0(mean, std, median), T200-T0(mean, std, median), T500-T0(mean, std,median), ...
            %  sbiStrength(mean, std, median],sbiThickness(mean, std, median], [# SBIs, # nonSBIs]
            % ref: doc/Approaches.pptx: Monthly Statistics Slides
            %------------------------------------------------------------
            outRow=[];
            if ~exist(monthlyProfileFileName, 'file')
                return;
            end

            tab =  readmatrix(monthlyProfileFileName, 'NumHeaderLines', 1);
            %---------------------------------------------------
            %tab: N x 32, [height, day1, ..., day31]
            %(see doc/Appraches.ppt -> slide Monthly Profile
            %---------------------------------------------------

            [nRows, nCols] = size(tab);

            assert( nCols==32, 'the monthly profile tab should be 32 cols!');
            assert(nRows>8, "the monthly profile tab should be more than 6 rows!");

            T0_stats  = UtilFuncs.calMeanStdMedian(tab(1, 2:32));                       %1:       T0: (mean, std, median)
            T200_stats  = UtilFuncs.calMeanStdMedian(tab(nRows-6, 2:32));               %nRows-6: T200-T0: (mean, std, median)
            T500_stats  = UtilFuncs.calMeanStdMedian(tab(nRows-5, 2:32));               %nRows-5: T500-T0: (mean, std, median)
            [numSBIs, numNonSBIs]  = UtilFuncs.calSbiNonSbiNum(tab(nRows-4, 2:32));     %nRows-4: [# SBIs, # nonSBIs]
            sbiStrength_stats  = UtilFuncs.calMeanStdMedian(tab(nRows-3, 2:32));        %nRows-3: sbiStrength(mean, std, median]
            sbiThickness_stats  = UtilFuncs.calMeanStdMedian(tab(nRows-2, 2:32));       %nRows-2: sbiThickness(mean, std, median]
            %nRows-1: SBI inversion point Temperature
            %nRows:   SBI inversion point height

            outRow = [T0_stats, T200_stats, T500_stats, sbiStrength_stats, sbiThickness_stats, numSBIs, numNonSBIs];
        end
    end
end

