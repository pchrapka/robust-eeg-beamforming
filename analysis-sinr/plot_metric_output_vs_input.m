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
% h = figure('Position',[100 100 1000 800]);
h = figure();
% pos = get(h, 'Position');
% pos(3:4) = pos(3:4)*1.5;
% set(h,'Position', pos);
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
        'color', colors(i,:), 'marker', markers{i},...
        'linewidth',2);
    hold on;
end
font_size = 14;
ylabel(output.label_y,'FontSize',font_size);
xlabel(output.label_x,'FontSize',font_size);
xlim([min(output.data(:,1)) max(output.data(:,1))]);
set(gca,'FontSize',font_size);
l = legend(legend_str{:}, 'Location','NorthWest');
set(l,'FontSize', font_size - 4);

% Save the figure
if cfg.save_fig
    cfg_save = [];
    % Get the data file name
    cfg.file_type = 'img';
    data_file = metrics.filename(cfg);
    % Get the data file dir
    [cfg_save.out_dir,~,~] = fileparts(data_file);
    
    % Set up the image file name
    % get file name from metrics file
    [~,outfile,~] = fileparts(cfg.data_file);
    cfg_save.file_name = outfile; % already has the tag
    
    fprintf('Saving figure: %s\n', cfg_save.file_name);
    % Set the background to white
    set(gcf, 'Color', 'w');
    lumberjack.save_figure(cfg_save);
    close(h);
end

end
