function plot_sinr_vs_snr(cfg)
%
%   cfg.beam_cfgs
%       cell array of beamformer configs
%   cfg.snrs
%       array of input data snrs
%   cfg.metrics
%       struct specifying sinr metric specification
%   cfg.force
%       flag for forcing recomputation of metrics, default = false
%   cfg.save_tag
%       tag for saving the data
%   cfg.save_fig
%       flag for saving figures, default = false

if ~isfield(cfg, 'force'), cfg.force = false; end
if ~isfield(cfg, 'save_fig'), cfg.save_fig = false; end

% Set up output
output = [];
output.bf_name = cfg.beam_cfgs;
output.data = zeros(length(cfg.snrs), 1+length(cfg.beam_cfgs));

% Set up the output file name based on data set
data_file = metrics.filename(cfg);

% img_dir = 'img';
% Set up metrics dir in data set dir
out_dir = 'metrics';
cfg_out = [];
cfg_out.file_name = data_file;
cfg_out.save_name = [filesep out_dir filesep...
    'metrics_outputsinr_vs_inputsnr_loc'...
    num2str(cfg.metrics.location_idx)];
cfg_out.tag = cfg.save_tag;
cfg_out.ext = '.mat';
% Generate file name
out_file = db.save_setup(cfg_out);

% Check if the data exists
if exist(out_file, 'file') && ~cfg.force
    fprintf('Loading: %s\n', out_file);
    % Load the data
    din = load(out_file);
    output = din.output;
else
    
    % Loop over beamformers
    for m=1:length(cfg.beam_cfgs)
        
        % Loop through snrs
        for i=1:length(cfg.snrs)
            snr = cfg.snrs(i);
            
            % Select beamformer
            cfg.beam_cfg = cfg.beam_cfgs{m};
            
            % Calculate the metrics
            cfg.metrics.name = 'sinr';
            cfg.data_set.snr = snr;
            out = metrics.run_metrics_on_file(cfg);
            
            % Extract the output
            output.data(i,1) = snr;
            output.data(i,1+m) = out.metrics(1).output.sinrdb;
            
        end
        
        % Set line style based on bf name
        if ~isempty(strfind(output.bf_name{m}, 'rmv'))
            output.line_style{m} = '--';
        elseif ~isempty(strfind(output.bf_name{m}, 'lcmv_eig'))
            output.line_style{m} = ':';
        else
            output.line_style{m} = '-';
        end
        % Fix the legend label
        output.bf_name{m} = util.fix_label(output.bf_name{m});
    end
    
    % Save output data
    fprintf('Saving %s\n', out_file);
    save(out_file, 'output');
    
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
legend(output.bf_name{:}, 'Location', 'SouthEast');
ylabel('Output SINR (dB)');
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
    cfg_save.file_name = ['metrics_outputsinr_vs_inputsnr_loc'...
        num2str(cfg.metrics.location_idx) '_' cfg.save_tag];
    fprintf('Saving figure: %s\n', cfg_save.file_name);
    % Set the background to white
    set(gcf, 'Color', 'w');
    lumberjack.save_figure(cfg_save);
    close(h);
end

end