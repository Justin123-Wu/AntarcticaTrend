function myLim = adjustPlotLim(x, perct)
xmin = min(x); 
xmax = max(x); 
dx = xmax-xmin;
xmin = xmin - perct * dx;
xmax = xmax + perct * dx;
myLim = [xmin, xmax];
end

