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

if ~isfield(cfg, 'force'), cfg.force = false; end

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
    fprintf('Loading %s\n', out_file);
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
    end
    
    % Save output data
    fprintf('Saving %s\n', out_file);
    save(out_file, 'output');
    
end

% Plot the data
figure;
plot(output.data(:,1), output.data(:,2:end));
% TODO Fix legend labels
legend(output.bf_name{:}, 'Location', 'SouthEast');
ylabel('Output SINR (dB)');
xlabel('Input SNR (db)');

% Save the figure
% TODO Save the figure

end