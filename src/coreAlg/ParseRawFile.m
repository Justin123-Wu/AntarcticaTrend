classdef ParseRawFile 
    properties
        obsArray=[];
        numOfObservations=0;
        maxHeightAboveGround=0;
        station=[];
    end

    methods
        function obj = ParseRawFile( myStation,  numOfObservationsToParse )
            
            currObs = Observation(myStation.name, myStation.baseAlt_m); % Create a new instance of Y2dObservation with 'stationName' and 'baseAlt_meter'.
            
            %pre-allocated 100 observations
            n=100;
            obj.station = myStation;
            obj.obsArray = currObs;    %initialized obsArray as an instance of the Observation class
            obj.obsArray(n) = currObs; %create an array with 100 element initially
            maxH = 0;
            %the above line preallocated space to the array, for n
            %instances of y2dObservation, creating n objects initialized
            %under the same parameter

            %open file to read line-by-line
            fid = fopen(myStation.rawFilePath); 
            cnt = 0; %used to count observations processed
            while true
                %read a headline if have
                headLine = fgetl(fid);
                if mod(cnt, 1000)==0
                    disp(headLine);
                end
                if ~ischar( headLine ) %if it is not the headline, then quit the loop
                    break;
                end

                %parse headline and get NUMLEV which is also # of data
                %lines for current observation
                currObs = currObs.parseHead( headLine );
                numDataLines = currObs.NUMLEV;  

                %Read all other data lines of current observation
                vecLines = cell(numDataLines,1); %vecLines array is initialized with 1 column and numDataLines rows
                for i=1:numDataLines %each cell will hold one line of text from the file 'fid'
                    vecLines{i} = fgetl(fid); %now that the next line of text is read, assign it to the ith cell of vecLines
                end

                %parse all the data lines of current observation
                currObs = currObs.parseDataLines( vecLines );
                currObs = currObs.calculateZ2();

                currMaxH = currObs.z2Alt(end);
                if ~isnan(currMaxH)
                    maxH = max(maxH, currMaxH);
                end
                %store currObs into obsArray
                cnt = cnt + 1;
                obj.obsArray(cnt) = currObs;

                if( cnt>=numOfObservationsToParse )
                    break;
                end
            end %end while
            fclose(fid);
            
            %delete extra pre-allocated elements
            obj.obsArray( (cnt+1) : n ) =[];

            obj.numOfObservations = cnt;
            obj.maxHeightAboveGround = maxH - myStation.baseAlt_m;          
        end

        function [tab] = getMonthlyObs( obj, yy1, yy2 )
            n = (yy2-yy1+1)*12;
            tab = nan(n,3);
            cnt=0;
            for yy=yy1:yy2
                for mm=1:12
                    vecIds = obj.findIndicesByYearMonth(yy, mm);
                    
                    cnt = cnt +1;
                    tab(cnt, :) = [yy,mm, numel(vecIds)];
                end
            end
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

        %given year, month, day, find all the corresponding indices in
        %<obsArray>
        function vecIds = findIndicesByYearMonth(obj, y, m)
            vecIds = [];
            for i=1 : obj.numOfObservations
                if obj.obsArray(i).YEAR == y & obj.obsArray(i).MONTH == m 
                    vecIds = [vecIds, i];
                end 
            end
        end
        
        %find the year range [Y1,Y2] in <obsArray> of the current file
        function [Y1, Y2] = findYearRange(obj)
            Y1=nan; Y2=nan; 
            if obj.numOfObservations<1
                return;
            end

            Y1 = obj.obsArray(1).YEAR;
            Y2 = obj.obsArray(end).YEAR;
            for i=1: obj.numOfObservations
                if obj.obsArray(i).YEAR < Y1
                    Y1 = obj.obsArray(i).YEAR;
                elseif obj.obsArray(i).YEAR > Y2
                    Y2 = obj.obsArray(i).YEAR;
                end 
            end
        end
        
        %------------------------------------------------------------------
        %create monthly profile csv files for   future processing
        %Ref: doc/Approaches.pptx, Monthly Profile slide
        %------------------------------------------------------------------
        function calculateAndSaveAllMonthlyProfiles(obj)
            [Y1,Y2] = obj.findYearRange();
            for y=Y1:Y2
                fprintf("y=%d\n", y);
                for m=1:12
                    fileName =  obj.station.getMonthlyProfileFilePath(y,m);
                    [profTable] = obj.calculateMonthlyTempProfile(y,m);
                    if isempty(profTable) || UtilFuncs.isAllNan( profTable(:,2:end) )
                        continue;
                    end

                   %profTable: numHeightPts x 32, each row has
                   %           [height, day1, ..., day31]

                    %-----------------------------------
                    %-- computer T200-T0 and T500-T0
                    %-----------------------------------
                    T200Idx = UtilFuncs.findHeighProfileIndex(profTable(:,1), 200);
                    T500Idx = UtilFuncs.findHeighProfileIndex(profTable(:,1), 500);

                    T0   = profTable(1, 2:end);
                    T200Row = [nan, profTable(T200Idx, 2:end) - T0];
                    T500Row = [nan, profTable(T500Idx, 2:end) - T0];
                    
                    [hasSbiRow, sbiStrengthRow, sbiDepthRow, sbiInvTempRow, sbiInvHeightRow] = calSbiMonthlyRaw(profTable);
                    
                    %add 5 more rows at the end of profTable
                    profTable = [profTable; ...
                        T200Row; ...
                        T500Row; ...
                        hasSbiRow; ...
                        sbiStrengthRow; ...
                        sbiDepthRow;...
                        sbiInvTempRow;...
                        sbiInvHeightRow];

                    %save as text file
                    varNames = cell(32,1); 
                    varNames{1} = 'height(m)';
                    for d=1:31
                        varNames{d+1} = ['day', num2str(d)]; 
                    end
                    T = array2table( single(profTable),'VariableNames',varNames);
                    writetable(T, fileName);
                end
            end
        end
        
        function [ profileTable ] = calculateMonthlyTempProfile(obj, year, month)
           %profileTable: numHeightPts x (31+3), [height, day1Temp, ..., day31Temp]

           %step 1: generate height sample points
           h = UtilFuncs.generateHeightProfile(obj.station.baseAlt_m);  % numHeightPts x 1

           %step 2: create output table
           numHeightPts = numel(h);
           profileTable = nan( numHeightPts, 31+1);   %[height, day1Temp, ..., day31Temp]

           profileTable(:,1) = h;
           %step 3: fill output table column-by-column 
           for day=1:31
                %each day may have multiple observations
                vecIds = obj.findIndices(year, month, day);
                if isempty( vecIds )
                    % tempTable(:, day) will be nan by init
                    continue;
                end

                sumTemp = zeros(numHeightPts,1);
                numDays = numel(vecIds);
                for j=1:numDays
                    idx = vecIds(j);
                    newTemp = obj.obsArray(idx).interpolateTempValues(h, obj.station.interpMethod);
                    if isempty(newTemp)
                        fprintf('warning: interp failed!: y=%d,m=%d,d=%d\n', year,month, day);
                    end
                    sumTemp = sumTemp  + newTemp(:);
                end
                profileTable(:, 1+day) = sumTemp/numDays;
           end
        end


        function dumpObervationResults( obj )
            [Y1,Y2] = obj.findYearRange();
            for y=Y1:Y2
                for m=1:12
                    vecIds = obj.findIndicesByYearMonth(y, m);
                    if isempty(vecIds)
                        continue;
                    end

                    fileName =  obj.station.getMonthlyObservationFilePath(y,m);
                    fid = fopen( fileName, 'w' );
                    for id = vecIds
                        obj.obsArray(id).dump_parsed_data(fid);
                    end
                    fclose(fid);
                end %m
            end %y
        end

        function dumpInfo( obj, fid )
            dd =  obj.obsArray(1);
            begDate = datestr(datenum( dd.YEAR, dd.MONTH, dd.DAY ));
            dd =  obj.obsArray(end);
            endDate = datestr(datenum( dd.YEAR, dd.MONTH, dd.DAY ));

            fprintf(fid, '%s, %s, %s, numOfObservations=%d, maxHeightAboveGround=%d\n', ...
                obj.station.name, begDate, endDate, obj.numOfObservations, obj.maxHeightAboveGround );
        end
        
    end

end
