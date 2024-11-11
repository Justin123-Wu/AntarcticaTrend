%The Observation class represents a data structure for storing and manipulating atmospheric 
% observation data typically obtained from weather stations or similar instruments. 
% organizes data into properties that correspond to specific fields in a data file.
classdef Observation %each instance of the class represents observations from the datafile
    properties
        stationName=''; %This property identifies the specific station where the observation data originates, ensuring each instance is associated with its correct source.
        %header info
        HEADREC='';   %  1-  1  Character
        ID='';        %  2- 12  Character
        YEAR=0;       %  14- 17  Integer
        MONTH=0;      %  19- 20  Integer
        DAY=0;        %  22- 23  Integer
        HOUR=0;       %  25- 26  Integer
        RELTIME=0;    %  28- 31  Integer
        NUMLEV=0;     %  33- 36  Integer
        P_SRC='';     %  38- 45  Character
        NP_SRC='';    %  47- 54  Character
        LAT=0;        %  56- 62  Integer
        LON=0;        %  64- 71  Integer
        z1Alt = 0; %serves as a baseline reference, crucial for subsequent altitude calculations.
        
        % -------------------------------
        % Variable        Columns Type
        % -------------------------------
        % LVLTYP1         1-  1   Integer
        % LVLTYP2         2-  2   Integer
        % ETIME           4-  8   Integer
        % PRESS          10- 15   Integer
        % PFLAG          16- 16   Character
        % GPH            17- 21   Integer
        % ZFLAG          22- 22   Character
        % TEMP           23- 27   Integer
        % TFLAG          28- 28   Character
        % RH             29- 33   Integer
        % DPDP           35- 39   Integer height vs temp
        % WDIR           41- 45   Integer
        % WSPD           47- 51   Integer
        % -------------------------------

        %data info
        lvlType1=[];
        lvlType2=[];
        etime=[];   %sec since launch
        press=[];
        pFlag = [];
        gph = [];
        zFlag = [];
        temp = [];
        tFlag = [];
        rh = [];
        dpdp = [];
        wdir = [];
        wspd = [];
        z2Alt =[]
    end

    methods
        function obj = Observation( stationName_, z1Alt_ ) 
            % constructor function for the Observation class.
            % Creates an instance of Observation with specified station name and z1 altitude.
            if nargin > 0 %see if there are input arguments provided 
                obj.stationName = stationName_; %assigns a station name to the stationName property of the object
                obj.z1Alt  = z1Alt_;
            end
        end

        function obj = parseDataLines(obj, vecDataLines) %for each line of parsed data, values are extracted using function parseAntLine
            numLev = numel( vecDataLines );
            assert( numLev == obj.NUMLEV);
            obj = obj.reSizeArrays( numLev );
            for i=1:numLev
                tline = vecDataLines{i};
                [lvlType1_, lvlType2_, etime_, press_, pFlag_, gph_, zFlag_, temp_, tFlag_, rh_, dpdp_, wdir_, wspd_ ] = parseAntLine( tline );

                obj.lvlType1(i) = lvlType1_; %assigns each parsed value into the respective array (columns)
                obj.lvlType2(i) = lvlType2_;
                obj.etime(i) = etime_;
                obj.press(i) = press_;
                obj.pFlag(i) = pFlag_;
                obj.gph(i) = gph_;
                obj.zFlag(i) = zFlag_;
                obj.temp(i) = temp_;
                obj.tFlag(i) = tFlag_;
                obj.rh(i) = rh_;
                obj.dpdp(i) = dpdp_;
                obj.wdir(i) = wdir_;
                obj.wspd(i) = wspd_;
            end
        end

        function obj = calculateZ2(obj)
            Rd =  287;  
            g  = 9.8;
            z1 = obj.z1Alt;
            T1 = obj.temp(1); 
            p1 = obj.press(1)/100;  %from Pa to hPa
            obj.z2Alt(1) = z1;
            if isnan(T1) | isnan(p1)
                obj.z2Alt(:)=nan;
                return;
            end

            for i=2:obj.NUMLEV
                T2 = obj.temp(i); 
                p2 = obj.press(i)/100;    %from Pa to hPa
                if  isnan(T2) | isnan(p2)
                    obj.z2Alt(i) = nan;
                else
                    T = (T1 + T2)/2 + 273.15;  %C to K
                    z2 = z1 + (Rd * T)/g * log(p1/p2);  %natural log
                    obj.z2Alt(i) = z2;
                    %for calculating z2 next time
                    T1 = T2;
                    p1 = p2;
                    z1 = z2;
                end
            end

        end

        function  obj = parseHead( obj, headLine )
            obj.HEADREC = headLine(1);   %  1-  1  Character
            obj.ID = headLine(2:12);        %  2- 12  Character
            obj.YEAR = str2double(headLine(14:17));       %  14- 17  Integer
            obj.MONTH = str2double(headLine(19:20));      %  19- 20  Integer
            obj.DAY = str2double(headLine(22:23));        %  22- 23  Integer
            obj.HOUR = str2double(headLine(25:26));       %  25- 26  Integer
            obj.RELTIME = str2double(headLine(28:31));    %  28- 31  Integer
            obj.NUMLEV = str2double(headLine(33:36));     %  33- 36  Integer
            obj.P_SRC  = headLine(38:45);     %  38- 45  Character
            obj.NP_SRC = headLine(47:54);     %  47- 54  Character
            obj.LAT = str2double(headLine(56:62));        %  56- 62  Integer
            obj.LON = str2double(headLine(64:71));        %  64- 71  Integer
        end

        function obj = reSizeArrays( obj, numLev )
            obj.NUMLEV = numLev;
            obj.lvlType1 = nan(numLev, 1);  %nLine x 1
            obj.lvlType2 = nan(numLev, 1);  %nLine x 1
            obj.etime = nan(numLev, 1);     %nLine x 1
            obj.press = nan(numLev, 1);
            obj.pFlag = repmat(' ', numLev, 1);
            obj.gph = nan(numLev, 1);
            obj.zFlag = repmat(' ', numLev, 1);
            obj.rh = nan(numLev, 1);
            obj.temp = nan(numLev, 1);
            obj.tFlag = repmat(' ', numLev, 1);
            obj.dpdp = nan(numLev, 1);
            obj.wdir = nan(numLev, 1);
            obj.wspd = nan(numLev, 1);
            obj.z2Alt = nan(numLev, 1);
        end

         function dump_parsed_data(obj, fid)
             fprintf( fid, '%c%s,Y=%d,M=%d,D=%d,H=%d,%d,%d,%s,%s,lat=%f,lon=%f,z1Alt=%f\n', ...
             obj.HEADREC, ...  %  1-  1  Character
             obj.ID,      ...   %  2- 12  Character
             obj.YEAR,    ...     %  14- 17  Integer
             obj.MONTH,   ...     %  19- 20  Integer
             obj.DAY,     ...      %  22- 23  Integer
             obj.HOUR,     ...     %  25- 26  Integer
             obj.RELTIME,  ...    %  28- 31  Integer
             obj.NUMLEV,   ...    %  33- 36  Integer
             obj.P_SRC,    ...   %  38- 45  Character
             obj.NP_SRC,  ...  %  47- 54  Character
             obj.LAT,     ...  %  56- 62  Integer
             obj.LON,     ...  %  64- 71  Integer
             obj.z1Alt);
             
             %instead of save flags as char, we save them as ascii, because
             %the space (' ') of a char is hard to read
             fprintf( fid, 'LVLTYP1,LVLTYP2,ETIME(sec since launch),PRESS,PFLAG(ascii),GPH,ZFLAG(ascii),TEMP,TFLAG(asscii),RH,DPDP,WDIR,WSPD,Z2Alt(m)\n');
             for i=1:obj.NUMLEV
                fprintf( fid, '%d,%d,%d,%d,PF=%d,%d,ZF=%d,%.4f,TF=%d,%.4f,%.4f,%.4f,%.4f,%.4f\n', ...
                obj.lvlType1(i), ...
                obj.lvlType2(i), ...
                obj.etime(i), ...
                obj.press(i), ...
                obj.pFlag(i), ...
                obj.gph(i), ...
                obj.zFlag(i), ...
                obj.temp(i), ...
                obj.tFlag(i), ...
                obj.rh(i), ...
                obj.dpdp(i), ...
                obj.wdir(i), ...
                obj.wspd(i), ...
                obj.z2Alt(i));
             end
         end

         function [obj, isEof] = read_parsed_data(obj, fid)
             % this function reads one observation from an opened
             % yyyy-mm-observation.csv file. The file is a pile of 
             % the following sections
             %
             %#AYM00089009,Y=2021,M=1,D=1,H=0,2102,78,ncdc-gts,        ,lat=-900000.000000,lon=0.000000,z1Alt=2835.000000
             %LVLTYP1,LVLTYP2,ETIME(sec since launch),PRESS,PFLAG(ascii),GPH,ZFLAG(ascii),TEMP,TFLAG(asscii),RH,DPDP,WDIR,WSPD,Z2Alt(m)
             %2,1,NaN,67800,PF=66,NaN,ZF=32,-29.7000,TF=66,NaN,4.5000,75.0000,2.1000,2835.0000
             %2,0,NaN,67700,PF=32,NaN,ZF=32,-31.1000,TF=66,NaN,2.2000,-9999.0000,NaN,2845.4931
             %2,0,NaN,66700,PF=32,NaN,ZF=32,-30.1000,TF=66,NaN,4.3000,-9999.0000,NaN,2951.1982
             %2,0,NaN,59200,PF=32,NaN,ZF=32,-32.9000,TF=66,NaN,2.8000,-9999.0000,NaN,3795.3541
             %2,0,NaN,57600,PF=32,NaN,ZF=32,-34.3000,TF=66,NaN,1.6000,-9999.0000,NaN,3987.5687
             %1,0,NaN,50000,PF=32,4970,ZF=66,-39.5000,TF=66,NaN,4.2000,255.0000,1.5000,4966.5688
             %2,0,NaN,45400,PF=32,NaN,ZF=32,-42.9000,TF=66,NaN,4.2000,-9999.0000,NaN,5622.1501
             % ...
             %2,0,NaN,1690,PF=32,NaN,ZF=32,-26.5000,TF=66,NaN,46.0000,160.0000,5.1000,27999.7851

             % Read head line (metaobj)
             isEof = false;
             headerLine = fgetl(fid);
             if headerLine<0
                 isEof = true;
                 return
             end

             % Parse the head line (metaobj)
             %headerLine='#AYM00089009,Y=1961,M=1,D=1,H=0,9999,12,ncdc6310,        ,lat=-900000.000000,lon=0.000000,z1Alt=2835.000000'
             line_cleaned = regexprep(headerLine, 'Y=|M=|D=|H=|lat=|lon=|z1Alt=', '');
             %line_cleaned='#AYM00089009,1961,1,1,0,9999,12,ncdc6310,        ,-900000.000000,0.000000,2835.000000'

             A = textscan(line_cleaned, '%s', 'Delimiter', ',');
             C = A{1};
             % Store metaobj in a structure
             obj.HEADREC = C{1}(1);
             obj.ID = C{1}(2:end);
             obj.YEAR = str2double(C{2});
             obj.MONTH = str2double(C{3});
             obj.DAY = str2double(C{4});
             obj.HOUR = str2double(C{5});
             obj.RELTIME = str2double(C{6});
             obj.NUMLEV = str2double(C{7});
             obj.P_SRC = C{8};
             obj.NP_SRC = C{9};
             obj.LAT = str2double(C{10});
             obj.LON = str2double(C{11});
             obj.z1Alt = str2double(C{12});

             % Initialize arrays to hold the obj
             obj.lvlType1 = nan(obj.NUMLEV, 1);
             obj.lvlType2 = nan(obj.NUMLEV, 1);
             obj.etime = nan(obj.NUMLEV, 1);
             obj.press = nan(obj.NUMLEV, 1);
             obj.pFlag = repmat(' ', obj.NUMLEV, 1);  % Initialize as characters
             obj.gph = nan(obj.NUMLEV, 1);
             obj.zFlag = repmat(' ', obj.NUMLEV, 1);  % Initialize as characters
             obj.temp = nan(obj.NUMLEV, 1);
             obj.tFlag = repmat(' ', obj.NUMLEV, 1);  % Initialize as characters
             obj.rh = nan(obj.NUMLEV, 1);
             obj.dpdp = nan(obj.NUMLEV, 1);
             obj.wdir = nan(obj.NUMLEV, 1);
             obj.wspd = nan(obj.NUMLEV, 1);
             obj.z2Alt = nan(obj.NUMLEV, 1);

             % Read the next line (column headers)
             coHeaders = fgetl(fid);
             %coHeaders='LVLTYP1,LVLTYP2,ETIME,PRESS,PFLAG,GPH,ZFLAG,TEMP,TFLAG, RH,      DPDP,      WDIR,    WSPD,  Z2Alt(m)'

             % Read the level obj
             for i = 1:obj.NUMLEV
                 line = fgetl(fid);
                 %line='2,1,NaN,67800,PF=66,NaN,ZF=32,-29.7000,TF=66,NaN,4.5000,75.0000,2.1000,2835.0000'
                 line_cleaned = regexprep(line, 'PF=|ZF=|TF=', '');
                 %line_cleaned='2,1,NaN,67800,66,NaN,32,-29.7000,66,NaN,4.5000,75.0000,2.1000,2835.0000'
                 A = textscan(line_cleaned, '%s', 'Delimiter', ',');
                 C = A{1};
                 obj.lvlType1(i) = str2double(C{1});
                 obj.lvlType2(i) = str2double(C{2});
                 obj.etime(i) = str2double(C{3});
                 obj.press(i) = str2double(C{4});
                 obj.pFlag(i) = char( str2double(C{5}) );
                 obj.gph(i) = str2double(C{6});
                 obj.zFlag(i) = char( str2double(C{7}) );
                 obj.temp(i) = str2double(C{8});
                 obj.tFlag(i) = char( str2double(C{9}) );
                 obj.rh(i) = str2double(C{10});
                 obj.dpdp(i) = str2double(C{11});
                 obj.wdir(i) = str2double(C{12});
                 obj.wspd(i) = str2double(C{13});
                 obj.z2Alt(i) = str2double(C{14});
             end
         end
         
         function [newTemp] = interpolateTempValues(obj, newZ2Alt, method)
            x = [obj.temp,  obj.z2Alt];           % m x 2, [temp, height]
            y =  UtilFuncs.remove_nan( x );       % n x 2  (n<=m), [temp, height]   
            [n,two] = size(y);
            
            %check height in increasing order

            % Interpolate temperature values
            if isempty(y) || (n<2)
                newTemp = nan( numel(newZ2Alt), 1);
            else
                %interp to find temperature given height
                newTemp = interp1( y(:,2), y(:,1), newZ2Alt, method);
            end
        end


        function plot_time_vs_temp(obj)
            figure 
            x = [obj.etime,  obj.temp]; % m x 2
            y =  UtilFuncs.remove_nan( x );       % n x 2  (n<=m)   

            plot(y(:,1), y(:,2), 'r-+');
            xlabel('elapsed time since launch (sec)');
            ylabel('temperature (C)');
            title( obj.ID );
        end

        function plot_temp_vs_height(obj, isInterp, interpMethod)
            if isInterp
              [newZ2Alt] = UtilFuncs.generateHeightProfile(obj.z1Alt);  % k x 1
              [newTemp] = obj.interpolateTempValues(newZ2Alt, interpMethod);
            end

            x = [obj.temp,  obj.z2Alt]; % m x 2
            y =  UtilFuncs.remove_nan( x );       % n x 2  (n<=m)   

            
            figure 
            box on
            hold on;
            grid on
            h0 = 0; %obj.z1Alt;
            plot(y(:,1), y(:,2)-h0, 'r+', 'MarkerSize', 30, 'LineWidth', 5 );
            if isInterp
                plot(newTemp, newZ2Alt-h0, 'bx-', 'LineWidth', 4);
                fprintf("height(m), interpolated Temp(C)\n");
                for i=1:size(newZ2Alt,1)
                    fprintf("%10.2f, %7.2f\n", newZ2Alt(i), newTemp(i) );
                end
            end
            legend('raw',  ['interpolated - ', interpMethod]);
            xlabel('Temperature (C)');
            if h0==0
                ylabel('Observation Elevation (m)');
                ylim([obj.z1Alt, obj.z1Alt+5000]);
            else
                ylabel('Observation Height above Base (m)');
                ylim([0, 5000]);
            end
            
            str = [ 'station:', obj.stationName, ', base elevation=', num2str(obj.z1Alt), '(m), '  obj.ID, '-', num2str(obj.YEAR, '%04d'), '-', num2str(obj.MONTH, '%02d'), '-', num2str(obj.DAY, '%02d'), ' HOUR', num2str(obj.HOUR, '%02d') ];
            title( str );
            ax = gca;
            ax.FontSize = 30;
            ax.BoxStyle = 'full';

        end

        

        function plot_temp_vs_dpdp(obj)
            figure
            x= [obj.temp, obj.dpdp];
            y= UtilFuncs.remove_nan(x);
            plot(y(:,1), y(:,2), 'r-+');
            xlabel('temperature (C)');
            ylabel('dewpoint depression (C)');
            title( obj.ID );
            str = [obj.ID, '-', num2str(obj.YEAR, '%04d'), '-', num2str(obj.MONTH, '%02d'), '-', num2str(obj.DAY, '%02d'), ' HOUR', num2str(obj.HOUR, '%02d') ];
            
            title( [obj.stationName, ': ', str] );
        end


        function plot_gph_vs_temp(obj)
            figure 
            x = [obj.gph,  obj.temp];   % m x 2
            y =  UtilFuncs.remove_nan( x );       % n x 2  (n<=m)   
            plot( y(:,1), y(:,2), 'b--d');
           
            xlabel('gph');
            ylabel('temperature (C)');
            title( obj.ID );
        end

        function plot_temp_vs_pressure(obj)
            figure 
            x = [obj.temp,  obj.press];   % m x 2
            y =  UtilFuncs.remove_nan( x );         % n x 2  (n<=m)   
         
            plot(y(:,1), y(:,2), 'b--d', 'MarkerSize', 8, 'LineWidth', 1.5);
            set ( gca, 'ydir', 'reverse' );
            set(gca, 'YScale', 'log');

            xlabel('temperature (C)');
            ylabel('pressure (Pa)');
            
            str = [obj.ID, '-', num2str(obj.YEAR, '%04d'), '-', num2str(obj.MONTH, '%02d'), '-', num2str(obj.DAY, '%02d'), ' HOUR', num2str(obj.HOUR, '%02d') ];
            
            title( [obj.stationName, ': ', str] );
            folderName = ['../graphs/', obj.stationName,  '/'];
            fileName = [folderName, obj.stationName, '-', str, '.png'];
            saveas(gcf,fileName)
        end
    end % end  methods

end %class
