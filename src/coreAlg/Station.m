classdef Station
    %------------------------------------------------------------------
    % our data files are organized by:
    % Antarctica/data
    %                 /raw
    %                      /AYM00089002-data.txt
    %                      /AYM00089009-data.txt  
    %                          ...
    %                      /AYM00089664-data.txt
    %                 /processed
    %                           /AYM00089002-data/
    %                           /AYM00089009-data/
    %                             ...
    %                           /AYM00089664-data/
    %----------------------------------------------------------------
    properties
        name = '';         % Name of the station
        rawFileTag = '';   % Raw file tag used in filenames
        baseAlt_m = 0;     % Base altitude in meters

        rawFilePath = '';  % Full path to the raw data file
        outputDir = '';    % Output directory for processed data       
        interpMethod='linear';
    end
    
    methods
        function obj = Station( name_, rawFileTag_, baseAlt_m_, dataDir_, interpMethod_ )
            obj.name = name_;
            obj.rawFileTag = rawFileTag_;
            obj.baseAlt_m = baseAlt_m_;
            obj.outputDir = fullfile( dataDir_, 'processed', [name_, '-', rawFileTag_] );
            obj.rawFilePath = fullfile( dataDir_, 'raw', [obj.rawFileTag, '.txt'] );
            
            obj.interpMethod = interpMethod_;

            [status, msg] = mkdir(  obj.outputDir );
            if ~isempty(msg)
               display( msg);
            end
        end

        function filePath = getMonthlyObservationFilePath(obj, y, m)
         filePath =  fullfile(obj.outputDir, [num2str(y, '%04d'), '-', num2str(m, '%02d'), '-observation.csv'] );
        end

        function filePath = getMonthlyProfileFilePath(obj, y, m)
         filePath =  fullfile(obj.outputDir, [num2str(y, '%04d'), '-', num2str(m, '%02d'), '-profile-', obj.interpMethod, '.csv'] );
        end
        
        function filePath = getMonthlyStatisticsFilePath(obj, begYear, endYear)
         filePath =  fullfile(obj.outputDir, ['monthlyStatistics-', num2str(begYear), '-', num2str(endYear), '-', obj.interpMethod, '.csv']);
        end

        function filePath = getSeasonalStatisticsFilePath(obj, begYear, endYear)
         filePath =  fullfile(obj.outputDir, ['seasonalStatistics-', num2str(begYear), '-', num2str(endYear), '-', obj.interpMethod, '.csv']);
        end
        
        function filePath = getSeasonalTempStatisticsPngFilePath(obj, begYear, endYear)
            filePath = fullfile( obj.outputDir, '..', [obj.name, '-temp-seasonal-stats-', num2str(begYear), '-', num2str(endYear), '-', obj.interpMethod, '.png']);
        end

        function filePath = getSeasonalSbiStatisticsPngFilePath(obj, begYear, endYear)
            filePath = fullfile( obj.outputDir, '..', [obj.name, '-sbi-seasonal-stats-', num2str(begYear), '-', num2str(endYear), '-', obj.interpMethod, '.png']);
        end

        function filePath = getMonthlyTempStatisticsPngFilePath(obj, begYear, endYear, seasonCode)
            filePath = fullfile( obj.outputDir, '..', [obj.name, '-temp-monthly-stats-', num2str(begYear), '-', num2str(endYear), '-S', num2str(seasonCode), '-', obj.interpMethod, '.png']);
        end

        function filePath = getMonthlySbiStatisticsPngFilePath(obj, begYear, endYear,seasonCode)
            filePath = fullfile( obj.outputDir, '..', [obj.name, '-sbi-monthly-stats-', num2str(begYear), '-', num2str(endYear), '-S', num2str(seasonCode), '-', obj.interpMethod, '.png']);
        end

        function disp( obj )
            fprintf( 'station: name=%s\n \t\t tag=%s\n \t\t baseAlt=%.2f(m)\n', obj.name, obj.rawFileTag, obj.baseAlt_m);
            fprintf( '\t\t rawDataFile=%s\n', obj.rawFilePath);
            fprintf( '\t\t outputDir=%s\n', obj.outputDir);
            fprintf( '\t\t interpMethod=%s\n', obj.interpMethod);
        end

    end
end
