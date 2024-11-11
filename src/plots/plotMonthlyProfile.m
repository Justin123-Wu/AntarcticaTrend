function plotMonthlyProfile( station, yy, mm, filterFlag, islog10Y)
%filterFlag= 1 only plot SBI, 0 only non-SBI, -1 only unknown, 
%otherwise plot all SBI, non-SBI, or unkmown SBI cases

monthlyProfileFileName = station.getMonthlyProfileFilePath(yy,mm);

%load observations for given year and month
mObs = ObservationMonthly( station,yy,mm );

%load monthly profile
mProfile =  readmatrix(monthlyProfileFileName, 'NumHeaderLines', 1);
%---------------------------------------------------
%mProfile: N x 32, [height, day1, ..., day31]
%(see doc/Appraches.ppt -> slide Monthly Profile
%---------------------------------------------------

[nRows, nCols] = size(mProfile);
assert( nCols==32, 'the monthly profile mProfile should be 32 cols!');
assert(nRows>6, "the monthly profile mProfile should be more than 6 rows!");
for dd=1:31
    %if dd==20
    %    disp('debug');
    %end

    vecIds = mObs.findIndices(yy, mm, dd);
    nObs = numel(vecIds);
    hh = gobjects(nObs,1);  

    sbiFlag  = mProfile(nRows-4, dd+1);     %[1- has SBI, 0- nonSBI, -1 -unknown]
    sbiStrength  = mProfile(nRows-3, dd+1);  %sbiStrength (C)
    sbiThickness  = mProfile(nRows-2, dd+1);   %sbiThickness (m)
    sbiInvPointT  = mProfile(nRows-1, dd+1);   %sbiInversion point Temp (C)
    sbiInvPointH  = mProfile(nRows, dd+1)-station.baseAlt_m;   %sbiInversion point height (m)

    %filterFlag=1 only plot SBI, 0 only non-SBI, -1 only unknown, otherwise
    %no filter
    if filterFlag == 1 || filterFlag == 0 || filterFlag == -1
        if sbiFlag ~= filterFlag
            continue;
        end
    end

    m = nRows-7; % the last row of the height (see monthly profile slide)

    x = mProfile(1:m, dd+1);                      %temp of the day
    y = mProfile(1:m, 1) - station.baseAlt_m;     %interpolated height from base
    
    xLim = adjustPlotLim(x, 0.05);
    yLim = adjustPlotLim(y, 0.0);
    if all(isnan(xLim), 'all')
        continue;
    end

    figure
    box on
    hold on;
    grid on
    vLegend = cell(nObs, 1);
    vColor={'r+', 'c+', 'm+', 'y+'};
    for i=1:nObs
        idx = vecIds(i);
        currObs = mObs.obsArray( idx  );
        tt = [currObs.temp,  currObs.z2Alt]; % m x 2
        th =  UtilFuncs.remove_nan( tt );       % n x 2  (n<=m)   
        th(:,2) = th(:,2) - station.baseAlt_m;
        if i<= 4
            curColor = vColor{i};
        else
            curColor = vColor{1};
        end
        if islog10Y
            hh(i) = semilogy( th(:, 1), th(:, 2), curColor, 'MarkerSize', 20, 'LineWidth', 3);
        else
            hh(i) = plot( th(:, 1), th(:, 2), curColor, 'MarkerSize', 20, 'LineWidth', 3);
        end
        vLegend{i} = ['observation ', num2str(i)];
    end

    if islog10Y
        hh(nObs+1) = semilogy(x, y, 'b-o', 'MarkerSize', 20, 'LineWidth', 3 );
    else
        hh(nObs+1) = plot(x, y, 'b-o', 'MarkerSize', 20, 'LineWidth', 3 );
    end
    if( sbiFlag == 1)
        vLegend{nObs+1} = ['interpolated by ', station.interpMethod, ' method'];
    elseif ( sbiFlag == 0)
        vLegend{nObs+1} = ['interpolated by ', station.interpMethod, ' method, Non SBI'];
    else
        vLegend{nObs+1} = ['interpolated by ', station.interpMethod, ' method, SBI unknown'];
    end
    
    if( sbiFlag == 1)
        %plot horizontal and vertical lines at inversion point
        if islog10Y
            hh(nObs+2)  = semilogy(xLim, [sbiInvPointH, sbiInvPointH], 'b--');
            semilogy([sbiInvPointT, sbiInvPointT], yLim, 'b--');
        else
            hh(nObs+2)  = plot(xLim, [sbiInvPointH, sbiInvPointH], 'b--');
            plot([sbiInvPointT, sbiInvPointT], yLim, 'b--');
        end
        vLegend{nObs+2} =['SBI, thickness=', num2str(sbiThickness), ', sbiStrength=', num2str(sbiStrength, '%.2f')];
    end

    legend( hh, vLegend);

    ylabel('Observation Height above Base (m)');
    xlabel('Temperature (C)');
    xlim( xLim );
    ylim( yLim );

    str = [station.name, ', interp: ', station.interpMethod, ', base elevation=', num2str(station.baseAlt_m), '(m), '  num2str(yy, '%04d'), '-', num2str(mm, '%02d'), '-', num2str(dd, '%02d')];
    title( str );
    ax = gca;
    ax.FontSize = 20;
    ax.BoxStyle = 'full';

end
end
