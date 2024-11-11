% Create a 2x2 grid of subplots
figure;
for i = 1:4
    subplot(2, 2, i);
    plot(rand(1, 10)); % Example plot, replace with data
    axis tight; % Fit axis limits to data
end

% Adjust the paper size to fit tightly around the content
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPositionMode', 'auto'); % Automatically adjust to fit the figure size
set(gcf, 'Position', get(gcf, 'OuterPosition') - [10, 10, -20, -20]); % Reduce figure margins

% Save the figure with a specified resolution
print(gcf, 'subplots.png', '-dpng', '-r300'); % 300 DPI resolution