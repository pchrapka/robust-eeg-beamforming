function plot_power_vs_distance_subplots(cfg)
%   cfg.legend_str
%       cell array of data labels
%   cfg.power
%       matrix of power data [locations series]
%   cfg.distance
%       vector of vertex distances in the same order as cfg.data_power,
%       does not need to be sorted
%   cfg.title

% Format legend strings
for i=1:length(cfg.legend_str)
    cfg.legend_str{i} = strrep(cfg.legend_str{i}, '_', ' ');
end

% Combine power and distance
data = [cfg.distance, cfg.power];
% Sort by distance
data = sortrows(data,1);

n_plots = size(data,2)-1; 
n_cols = 2;
n_rows = ceil(n_plots/n_cols);

figure;
for i=1:n_plots
    subplot(n_rows, n_cols, i);
    % Plot power data
    plot(data(:,1), data(:,1+i), 'LineWidth', 2);
    ylabel(cfg.legend_str{i});
    if i==1
        title(cfg.title);
    end
end

% Normalize the power data
n_locs = size(cfg.power,1);
data_power_norm = cfg.power./repmat(max(cfg.power), n_locs, 1);

% Combine power and distance
data = [cfg.distance, data_power_norm];
% Sort by distance
data = sortrows(data,1);

figure;
for i=1:n_plots
    subplot(n_rows, n_cols, i);
    % Plot normalized data
    plot(data(:,1), data(:,1+i), 'LineWidth', 2);
    ylabel(cfg.legend_str{i});
    if i==1
        title(['Normalized ' cfg.title]);
    end
end

end