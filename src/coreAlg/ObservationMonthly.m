%this class reads pre-saved monthly observation data
% data\processed\AYM00089009-data\yyyy-mm-observation.csv
classdef ObservationMonthly
    properties
        obsSatation=[];
        obsYear=0
        obsMonth=0
        
        obsArray=[];
        numOfObservations=0;
    end

    methods
        function obj = ObservationMonthly( station, yy, mm)
            n=50; %pre-allocated 50 observations
            obj.obsSatation = station;
            obj.obsYear = yy;
            obj.obsMonth = mm;
            obj.obsArray = Observation(station.name, station.baseAlt_m); %initialized obsArray as an instance of the Y2d class
            obj.obsArray(n) = Observation(station.name, station.baseAlt_m); %single object of type y2dObservation is created and the arguments within are passed to the constructor 
            obsFileName = station.getMonthlyObservationFilePath(yy, mm);

            %the above line preallocated space to the array, for n
            %instances of y2dObservation, creating n objects initialized
            %under the same parameter
            %open file to read line-by-line

            cnt = 0; %used to count the observations processed
            isEof = false;

            %Open file named <obsFileName> for the purpose of reading.
            fid = fopen(obsFileName); 
            while ~isEof
               %Create a new instance of Observation with 'stationName' and 'baseAlt_meter'.
               currObs = Observation(station.name, station.baseAlt_m); 
               
               [currObs,isEof] = currObs.read_parsed_data(fid);
               if ~isEof 
                   %store currObs into obsArray
                   cnt = cnt + 1;
                   obj.obsArray(cnt) = currObs;
               end
            end
            fclose(fid);
            %delete extra pre-allocated elements
            obj.obsArray( (cnt+1) : n ) =[];
            obj.numOfObservations = cnt;
        end

        %given year, month, day and hour, find its corresponding index in
        %<obsArray>
        function idx = findIndex(obj, y, m, d, h)
            idx = -1;
            for i=1: obj.numOfObservations
                if obj.obsArray(i).YEAR == y & obj.obsArray(i).MONTH == m & obj.obsArray(i).DAY == d & obj.obsArray(i).HOUR == h
                    idx = i;
                    break;
                end 
            end
        end

        %given year, month, day, find all the corresponding indices in
        %<obsArray>
        function vecIds = findIndices(obj, y, m, d)
            vecIds = [];
            for i=1 : obj.numOfObservations
                if obj.obsArray(i).YEAR == y & obj.obsArray(i).MONTH == m & obj.obsArray(i).DAY == d 
                    vecIds = [vecIds, i];
                end 
            end
        end

        function plot_temp_vs_pressure( obj, y, m, d )
            %plot temperatur vs. presure for all the observations given date
            vecIds = obj.findIndices(y, m, d);
            for index = vecIds
                obj.obsArray(index).plot_temp_vs_pressure();
            end
        end

        function plot_temp_vs_height( obj, y, m, d, isInterp, method )
            vecIds = obj.findIndices(y, m, d);
            for index = vecIds
                obj.obsArray(index).plot_temp_vs_height(isInterp, method);
            end
        end

        function plot_gph_vs_temp( obj, y, m, d )
            vecIds = obj.findIndices(y, m, d);
            for index = vecIds
                obj.obsArray(index).plot_gph_vs_temp();
            end
        end

        function plot_temp_vs_dpdp( obj, y, m, d )
            vecIds = obj.findIndices(y, m, d);
            for index = vecIds
                obj.obsArray(index).plot_temp_vs_dpdp();
            end
        end
    end
end
