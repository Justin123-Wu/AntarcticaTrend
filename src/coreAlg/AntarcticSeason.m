classdef  AntarcticSeason

    methods (Static)
        function [out] = getYearMonthFromSeasonCode(year, seasonCode)
            %given and year and season code, find its 4-months and corresponding years
            %out: 3 x 2: [year, month]
            if seasonCode==1
                %summer
                out = [[year-1, 12]; [year, 1]; [year, 2]];
            elseif seasonCode==2
                %Fall
                out = [[year, 3]; [year, 4]; [year, 5]];

            elseif seasonCode==3
                %Winter
                out = [[year, 6]; [year, 7]; [year, 8];];

            else
                %Spring
                out = [[year, 9]; [year, 10]; [year, 11];];
            end
        end
        function [vMonths] = getMonthsFromSeasonCode(seasonCode)
            %given and year and season code, find its 4-months and corresponding years
            %out: 3 x 2: [year, month]
            if seasonCode==1
                %summer
                vMonths = [12,1,2];
            elseif seasonCode==2
                %Fall
                vMonths = (3:5);
            elseif seasonCode==3
                %Winter
                vMonths = (6:8);
            else
                %Spring
                vMonths = (9:11);
            end
        end

        function [ss] = getSeasonNameFromCode(seasonCode)
            if seasonCode==1
                ss='Summer';
            elseif seasonCode==2
                ss='Fall  ';
            elseif seasonCode==3
                ss='Winter';
            elseif seasonCode==4
                ss='Spring';
            else
                ss='X';
            end
        end

        function [days] = getDaysFromSeasonCode(year, seasonCode)
            if seasonCode==1
                %summer: Dec, Jan, Feb
                days = 31 + 31 + 28;
                if leapyear( year )
                    days = days + 1;
                end
            elseif seasonCode==2
                %Fall: Mar, Apl, May
                days = 31 + 30 + 31;
            elseif seasonCode==3
                % Winter: Jun, Jul, Aug
                days = 30 + 31 + 31;
            elseif seasonCode==4
                % Spring: Sep, Oct, Nov
                days = 30 + 31 + 30;
            else
                days=nan;
            end
        end

        function sc = getSeasonalColor()
            sc.summer = [1 0 0];         %summer
            sc.fall = [0 0 1];         %fall
            sc.winter = [0 191/255, 1];  %winter
            sc.spring = [0 1 128/255];   %spring
        end

        function vFilepath = getSeasonalProfileFilePaths(dir0, yy, seasonCode, interpMethod)
            if seasonCode==1
                %summer
                v = { [num2str(yy-1), '-12'], [num2str(yy), '-01'], [num2str(yy), '-02'] };
            elseif seasonCode==2
                %Fall
                v = { [num2str(yy), '-03'], [num2str(yy), '-04'], [num2str(yy), '-05'] };
            elseif seasonCode==3
                %Winter
                v = { [num2str(yy), '-06'], [num2str(yy), '-07'], [num2str(yy), '-08'] };
            else
                %Spring
                v = { [num2str(yy), '-09'], [num2str(yy), '-10'], [num2str(yy), '-11'] };
            end

            vFilepath = { [dir0, '/', v{1}, '-profile-', interpMethod, '.csv'], ...
                [dir0, '/', v{2}, '-profile-', interpMethod, '.csv'], ...
                [dir0, '/', v{3}, '-profile-', interpMethod, '.csv'] };
        end

    end %methods (Static)
end %classdef  AntarcticSeason
