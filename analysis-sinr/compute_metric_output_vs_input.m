function [cfg] = compute_metric_output_vs_input(cfg)
%COMPUTE_METRIC_OUTPUT_VS_INPUT computes an output metric vs input metric
%   COMPUTE_METRIC_OUTPUT_VS_INPUT(cfg) computes an output metric vs input
%   metric
%
%   Parameters
%   ----------
%   cfg.metric_x
%       metric to compute on x axis
%       options: 'input snr'
%   cfg.metric_y
%       metric to compute on y axis
%       options: 'sinr', 'isnr'
%   cfg.data_set
%       data set
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

% set up output file name
outfile = sprintf('metrics_%s_vs_%s_loc%d',...
    strrep(cfg.metric_y,' ',''),...
    strrep(cfg.metric_x,' ',''),...
    cfg.metrics.location_idx);

% Set up the output file name based on data set
cfg.file_type = 'metrics'; % Set up a new metrics subdir
data_file = metrics.filename(cfg);
cfg_out = [];
cfg_out.file_name = data_file;
cfg_out.save_name = [filesep outfile];
cfg_out.tag = cfg.save_tag;
cfg_out.ext = '.mat';
% Generate file name
cfg.data_file = db.save_setup(cfg_out);

% Check if the data exists
if ~exist(cfg.data_file, 'file') || cfg.force
    % Compute the SINR if the file doesn't exist
    
    % Set up output
    output = [];
    output.bf_name = cfg.beam_cfgs;
    output.data = zeros(length(cfg.snrs), 1+length(cfg.beam_cfgs));
    
    % Loop over beamformers
    for m=1:length(cfg.beam_cfgs)
        
        % Loop through snrs
        for i=1:length(cfg.snrs)
            snr = cfg.snrs(i);
            
            % Select beamformer
            cfg.beam_cfg = cfg.beam_cfgs{m};
            cfg.data_set.snr = snr;
            
            switch cfg.metric_x
                % NOTE this should be common to all data sets
                case 'input snr'
                    
                    % Calculate the metrics
                    cfg.metrics.name = 'inputsnr';
                    out = metrics.run_metrics_on_file(cfg);
                    
                    % Extract the output
                    output.data(i,1) = out.metrics(1).output.snrdb;
                    
                otherwise
                    error('unknown metric %s', cfg.metric_x);
            end
            
            switch cfg.metric_y
                case 'output snr'
                    % Calculate the metrics
                    cfg.metrics.name = 'snr';
                    out = metrics.run_metrics_on_file(cfg);
                    
                    output.data(i,1+m) = out.metrics(1).output.snrdb;
                    
                case 'output sinr'
                    % Calculate the metrics
                    cfg.metrics.name = 'sinr';
                    out = metrics.run_metrics_on_file(cfg);
                    
                    output.data(i,1+m) = out.metrics(1).output.sinrdb;
                    
                case 'output isnr'
                    % Calculate the metrics
                    cfg.metrics.name = 'isnr';
                    out = metrics.run_metrics_on_file(cfg);
                    
                    output.data(i,1+m) = out.metrics(1).output.isnrdb;
                    
                otherwise
                    error('unknown metric: %s', cfg.metric_y);
            end
            
        end
    end
    
    % Save output data
    fprintf('Saving %s\n', cfg.data_file);
    save(cfg.data_file, 'output');
    
end

end