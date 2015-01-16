function plot_power_vs_distance(cfg)
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

figure;
subplot(1,2,1);

% Combine power and distance
data = [cfg.distance, cfg.power];
% Sort by distance
data = sortrows(data,1);

% Plot power data
plot(data(:,1), data(:,2:end), 'LineWidth', 2);
legend(cfg.legend_str{:});
title(cfg.title);

subplot(1,2,2);
% Normalize the power data
n_rows = size(cfg.power,1);
data_power_norm = cfg.power./repmat(max(cfg.power), n_rows, 1);

% Combine power and distance
data = [cfg.distance, data_power_norm];
% Sort by distance
data = sortrows(data,1);

% Plot normalized data
plot(data(:,1), data(:,2:end), 'LineWidth', 2);
legend(cfg.legend_str{:});
title(['Normalized ' cfg.title]);

end