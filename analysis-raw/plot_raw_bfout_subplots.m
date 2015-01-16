function plot_raw_bfout_subplots(cfg)
%   cfg.legend_str
%       cell array of data labels
%   cfg.data
%       data matrix [locations series]
%   cfg.title

% Format legend strings
for i=1:length(cfg.legend_str)
    cfg.legend_str{i} = strrep(cfg.legend_str{i}, '_', ' ');
end

data = cfg.data;

n_plots = size(data,2); 
n_cols = 2;
n_rows = ceil(n_plots/n_cols);

figure;
for i=1:n_plots
    subplot(n_rows, n_cols, i);
    % Plot power data
    plot(data(:,i), 'LineWidth', 2);
    ylabel(cfg.legend_str{i});
    if i==1
        title(cfg.title);
    end
end

% % Normalize the power data
% n_locs = size(cfg.data,1);
% data_power_norm = cfg.data./repmat(max(cfg.data), n_locs, 1);
% 
% % Combine power and distance
% data = [cfg.distance, data_power_norm];
% % Sort by distance
% data = sortrows(data,1);
% 
% figure;
% for i=1:n_plots
%     subplot(n_rows, n_cols, i);
%     % Plot normalized data
%     plot(data(:,1), data(:,1+i), 'LineWidth', 2);
%     ylabel(cfg.legend_str{i});
%     if i==1
%         title(['Normalized ' cfg.title]);
%     end
% end

end