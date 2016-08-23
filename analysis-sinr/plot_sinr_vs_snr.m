function plot_sinr_vs_snr(cfg)
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
        'SINR data not found %s\nRun compute_sinr_vs_snr and try again\n',...
        cfg.data_file);
end

% Plot the data
h = figure;
n_plots = size(output.data,2)-1;
colors = hsv(n_plots);
markers = {'o', 'x', 's', 'd', '^', 'v', '+', '>', '<'};
for i=1:n_plots
    % Loop through custom colors and line styles
    plot(output.data(:,1), output.data(:,1+i), output.line_style{i},...
        'color', colors(i,:), 'marker', markers{i});
    hold on;
end
legend(output.bf_name{:}, 'Location', 'SouthEast');
ylabel('Output SINR (dB)');
xlabel('Input SNR (db)');

% Save the figure
if cfg.save_fig
    cfg_save = [];
    % Get the data file name
    cfg.file_type = 'img';
    data_file = metrics.filename(cfg);
    % Get the data file dir
    [cfg_save.out_dir,~,~] = fileparts(data_file);
    
    % Set up the image file name
    cfg_save.file_name = ['metrics_outputsinr_vs_inputsnr_loc'...
        num2str(cfg.metrics.location_idx) '_' cfg.save_tag];
    fprintf('Saving figure: %s\n', cfg_save.file_name);
    % Set the background to white
    set(gcf, 'Color', 'w');
    lumberjack.save_figure(cfg_save);
    close(h);
end

end