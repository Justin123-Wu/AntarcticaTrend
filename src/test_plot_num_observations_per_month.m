function test_plot_num_observations_per_month
close all

addpath('./coreAlg/', './plots/');
interpMethod = 'linear';
dataDir = fullfile(pwd, '..', 'data');
vStations = StationArray(dataDir, interpMethod);
nStations = vStations.nTotStations;

outputFilename = './MonthlyNumOfObserations4AllStations.mat';
isReCal=0;
if isReCal
    %the parameters for each station
    numOfObsToRead = inf;  % inf - to read all overservations
    yy1 = 2000;
    yy2 = 2023;
    
    n = (yy2-yy1+1)*12;

    tab =  nan(n, nStations+2);
    %[yy,mm, #obs1,#obs2, #obs3, #obs4, #obs5, #obs6,#obs7]
    
    fid = fopen(['./', interpMethod, '-rawInfo.txt'], 'w');
    for i=1:nStations
        station = vStations.getStation(i);
        station.disp();

        obj = ParseRawFile(station, numOfObsToRead);

        %tt = [yy, mm, nObservations)
        tt = obj.getMonthlyObs( yy1, yy2 );

        if i==1
            tab(:, 1:3) = tt;
        else
            tab(:, 2+i) = tt(:, 3);
        end
    end %for i
    fclose(fid);

    save( outputFilename, "tab");

    plot_num_obs(tab, vStations);
else
    x = load(outputFilename);
    plot_num_obs(x.tab, vStations);
end

end


function plot_num_obs(tab, vStations)

[m,n] = size(tab);
nStation = n-2;

x = (1:m);
xTickValues = (1:12:m);
nTicks = numel(xTickValues);
xTickLabels = cell(nTicks,1);
for i=1:nTicks
    rowId = xTickValues(i);
    xTickLabels{i} = [num2str(tab(rowId,1))];
end

vColor = [1,0.5,0; %Amundsen-scott -- yellow
          0,0,1; %Rothera
          1,0,1;
          1,0,0;  %Syowa - red
          0,0,0;  %McMurdo - black
          0,1,0;  %Davis - green
          0,125/255,1];

figure 
hold on;
box on;
grid on;
vLegend = cell(nStation,1);
for i=1:nStation
    station = vStations.getStation(i);
    vLegend{i} = station.name;
    plot(x, tab(:, i+2),  'color', vColor(i,:), 'LineWidth', 3 );
end
legend( vLegend )
xticks( xTickValues );
xticklabels( xTickLabels );
xlim([0,m]);
ylim([0,120]);
ax = gca;
ax.FontSize = 25;
ylabel("Monthly Num. of Observations");
xlabel("Time");
end

