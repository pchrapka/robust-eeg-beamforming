function plot_rmse_vs_snr(cfg)
%
%   cfg.metrics
%       struct specifying sinr metric specification
%   cfg.data_file
%       file containing SINR data
%   cfg.save_tag
%       tag for saving the data
%   cfg.save_fig
%       flag for saving figures, default = false

if ~isfield(cfg, 'save_fig'), cfg.save_fig = false; end

% Check if the data exists
if exist(cfg.data_file, 'file')
    fprintf('Loading: %s\n', cfg.data_file);
    % Load the data
    din = load(cfg.data_file);
    output = din.output;
else
    error(['reb:' mfilename],...
        'RMSE data not found %s\nRun compute_rmse_vs_snr and try again\n',...
        cfg.data_file);
end

% Plot the data
h = figure;
n_plots = size(output.data,2)-1;
colors = hsv(n_plots);
for i=1:n_plots
    % Loop through custom colors and line styles
    plot(output.data(:,1), output.data(:,1+i), output.line_style{i},...
        'color', colors(i,:));
    hold on;
end
legend(output.bf_name{:});%, 'Location', 'BestOutside');
ylabel('RMSE Total');
xlabel('Input SNR (db)');

% Save the figure
if cfg.save_fig
    cfg_save = [];
    % Get the data file name
    data_file = metrics.filename(cfg);
    % Get the data file dir
    [save_dir,~,~] = fileparts(data_file);
    % Set up an img dir
    cfg_save.out_dir = fullfile(save_dir, 'img');
    % Set up the image file name
    cfg_save.file_name = ['metrics_rmse_vs_inputsnr_' cfg.metrics.component...
        '_loc' num2str(cfg.metrics.location_idx) '_' cfg.save_tag];
    cfg_save.options = {'-m2'};
    % FIXME location idx
    
    % Set the background to white
    set(gcf, 'Color', 'w');
    % Change the figure size
    position = get(gcf, 'Position');
    set(gcf, 'Position', [0 position(2) 800 600]);
    % Set y axis
    ylim_cur = ylim;
    ylim([0 ylim_cur(2)]);
    
    % Save the figure
    fprintf('Saving figure: %s\n', cfg_save.file_name);
    lumberjack.save_figure(cfg_save);
    close(h);
end

end