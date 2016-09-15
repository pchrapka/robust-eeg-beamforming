function plot_metric_output_vs_input(cfg)
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
        'SINR data not found %s\nRun compute_metric_output_vs_input and try again\n',...
        cfg.data_file);
end

% Plot the data
h = figure('Position',[100 100 1000 800]);
n_plots = size(output.data,2)-1;
colors = hsv(n_plots);
markers = {'o', 'x', 's', 'd', '^', 'v', '+', '>', '<'};
if n_plots > length(markers)
    nreps = ceil(n_plots/length(markers));
    markers = repmat(markers,1,nreps);
end

legend_str = cell(size(output.bf_name));
for i=1:n_plots
    % get line stype
    [legend_str{i},line_style] = get_beamformer_plot_style(output.bf_name{i});

    % Loop through custom colors and line styles
    plot(output.data(:,1), output.data(:,1+i), line_style,...
        'color', colors(i,:), 'marker', markers{i});
    hold on;
end
legend(legend_str{:}, 'Location', 'SouthEast');
ylabel('Output SINR (dB)');
xlabel('Input SNR (db)');

% Save the figure
if cfg.save_fig
    cfg_save = [];
    % Get the data file name
    cfg.file_type = 'img';
    data_file = metrics.filename(cfg);
    % Get the data file dir
    [cfg_save.out_dir,outfile,~] = fileparts(data_file);
    
    % Set up the image file name
    cfg_save.file_name = [outfile '_' cfg.save_tag];
    fprintf('Saving figure: %s\n', cfg_save.file_name);
    % Set the background to white
    set(gcf, 'Color', 'w');
    lumberjack.save_figure(cfg_save);
    close(h);
end

end
