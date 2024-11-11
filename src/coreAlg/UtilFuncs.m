classdef UtilFuncs
    methods (Static)
        function [flag] = isAllNan(x)
            flag = false;

            [m,n] = size(x);
            y = isnan(x);
            z = sum(y(:));
            if z==m*n
                flag = true;
            end
        end

        function [y] = calMeanStdMedian(x)
            I = ~isnan(x);     %find indices without nan
            x1 = x(I);          %nan removed
            xmean = mean(x1);
            xmedian = median(x1);
            xstd = std(x1);
            y = [xmean, xstd, xmedian];
        end

        function [numSBIs, numNonSBIs] = calSbiNonSbiNum( x )
            %x: 1 x n: SbiFlags: (1 –sbi, 0-nonSBI,-1 unknown)
            %for monthly/seasonal statistics x has 31 or( 62, or 93) elements
            %
            %if a month has less than 31 days, the corresponding element is nan
            %31 -- for monthly or season with only one months data.
            %62 -- for a season which only has two months data
            %93 -- for a season which has three months data

            n = numel(x);
            assert( n== 31 || n == 2*31 || n == 3*31, "x must has 31, 62 or 93 elements!");

            sbiI = (x==1);
            nonSbiI = (x==0);
            numSBIs = sum(sbiI);
            numNonSBIs = sum(nonSbiI);
        end

        function y =  remove_nan( x )
            %
            %if x(i,:) has NAN, the i-th row will be removed
            %
            %x m  x n: the raw matrix with nan elements
            %y m2 x n: output matrix without nan elements
            %----------------------------------
            [m, n] = size(x);

            %I is a boolean vector which indicates the rows in x have a nan value
            I = false(m,1);
            for i=1:n
                I = I | isnan(x(:,i));
            end

            %now I indicates the rows in x have a non-nan value
            I = ~I;

            y = x(I, :);
        end

        function [newHeights] = generateHeightProfile(baseAlt_meter)
            % newHeights:  n x 1 column  vector
            if  1
                height_0_to_1km = (0:10:1000); % 0 to 1km in 50m increments
                height_1km_to_5km = (1100:100:5000); % 1km to 5km in 100 m increments
                height_above_5km = (5200:200:10000); % above 5km in 200 m increments

                newHeights = baseAlt_meter + [height_0_to_1km, height_1km_to_5km, height_above_5km]';
            else
                newHeights = baseAlt_meter + (0:50:10000);
            end
        end
        
        function idx = findHeighProfileIndex( h, givenHeight)
            idx = nan;

            h0 =  h(1);  %base alt
            m = size(h);
            for i=2:m
                if  h(i) - h0 == givenHeight
                    idx = i;
                    break;
                end
            end
        end

    end
end


