function plot_series( data )
%PLOT_SERIES Plots data series
%   PLOT_SERIES(DATA) plots the data series provided in DATA.
%   DATA is a struct that represents each data series and includes the
%   following fields:
%       x       x data [POINTS, SIMULATION RUNS]
%       y       y data [POINTS, SIMULATION RUNS]
%       name    name of data series
%       xlabel  x data label
%       ylabel  y data label

hold all;
grid on;

n = length(data);
legend_str{n} = '';

markers = ['o', 's', 'v', '*', 'x'];

for k=1:n
    mean_x = mean(data(k).x,2);
    mean_y = mean(data(k).y,2);
    plot(mean_x, mean_y, markers(k));
    xlabel(data(k).xlabel);
    ylabel(data(k).ylabel);
    legend_str{k} = data(k).name;
end
legend(legend_str,'Location','Best');
xlim([min(mean_x) max(mean_x)]);

end

