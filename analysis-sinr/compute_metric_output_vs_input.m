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
%       SimDataSetEEG object
%   cfg.data_tag
%       tag for specific data analysis
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
if ~isfield(cfg.metrics, 'average'), cfg.metrics.average = true; end
if ~isfield(cfg.metrics, 'trial_idx'), cfg.metrics.trial_idx = 0; end
if ~isfield(cfg.metrics, 'data_idx'), cfg.metrics.data_idx = []; end
if ~isfield(cfg, 'data_tag'), error('data_tag is required'); end

% set up output file name
if cfg.metrics.average
    if ~isempty(cfg.metrics.data_idx)
        outfile = sprintf('metrics_%s_%s_vs_%s_loc%d_avg_data%d-%d',...
            cfg.data_tag,...
            strrep(cfg.metric_y,' ',''),...
            strrep(cfg.metric_x,' ',''),...
            cfg.metrics.location_idx,...
            cfg.metrics.data_idx(1),...
            cfg.metrics.data_idx(end));
    else
        outfile = sprintf('metrics_%s_%s_vs_%s_loc%d_avg',...
            cfg.data_tag,...
            strrep(cfg.metric_y,' ',''),...
            strrep(cfg.metric_x,' ',''),...
            cfg.metrics.location_idx);
    end
else
    if ~isempty(cfg.metrics.data_idx)
        outfile = sprintf('metrics_%s_%s_vs_%s_loc%d_trial%d-%d_data%d-%d',...
            cfg.data_tag,...
            strrep(cfg.metric_y,' ',''),...
            strrep(cfg.metric_x,' ',''),...
            cfg.metrics.location_idx,...
            cfg.metrics.trial_idx(1),...
            cfg.metrics.trial_idx(end),...
            cfg.metrics.data_idx(1),...
            cfg.metrics.data_idx(end));
    else
        outfile = sprintf('metrics_%s_%s_vs_%s_loc%d_trial%d-%d',...
            cfg.data_tag,...
            strrep(cfg.metric_y,' ',''),...
            strrep(cfg.metric_x,' ',''),...
            cfg.metrics.location_idx,...
            cfg.metrics.trial_idx(1),...
            cfg.metrics.trial_idx(end));
    end
end

% Set up the output file name based on data set
cfg.file_type = 'metrics'; % Set up a new metrics subdir
data_file = metrics.filename(cfg);

% Generate file name
cfg.data_file = db.save_setup(...
    'file_name',data_file,'save_name',[filesep outfile],'tag',cfg.save_tag);

% Check if the data exists
if ~exist(cfg.data_file, 'file') || cfg.force
    % Compute the SINR if the file doesn't exist
    
    % Set up output
    output = [];
    output.bf_name = cfg.beam_cfgs;
    output.data = zeros(length(cfg.snrs), 1+length(cfg.beam_cfgs));
    
    % Loop over beamformers
    for m=1:length(cfg.beam_cfgs)
        
        % save the original data set
        data_set = cfg.data_set;
        
        % Loop through snrs
        for i=1:length(cfg.snrs)
            snr = cfg.snrs(i);
            
            % Set up metrics config
            cfg_metrics = [];
            % Select beamformer
            cfg_metrics.beam_cfg = cfg.beam_cfgs{m};
            cfg_metrics.data_set = SimDataSetEEG(...
                data_set.sim,data_set.source,snr,'iter',1);
            cfg_metrics.metrics{1}.name = cfg.metric_x;
            cfg_metrics.metrics{1}.average = cfg.metrics.average;
            cfg_metrics.metrics{1}.trial_idx = cfg.metrics.trial_idx;
            cfg_metrics.metrics{1}.data_idx = cfg.metrics.data_idx;
            cfg_metrics.metrics{2}.name = cfg.metric_y;
            cfg_metrics.metrics{2}.location_idx = cfg.metrics.location_idx;
            cfg_metrics.metrics{2}.trial_idx = cfg.metrics.trial_idx;
            cfg_metrics.metrics{2}.data_idx = cfg.metrics.data_idx;
            % Calculate the metrics
            %out = metrics.run_metrics_on_file(cfg_metrics);
            bdm = BeamformerDataMetrics(cfg_metrics.data_set,cfg_metrics.beam_cfg);
            out = bdm.run_metrics(cfg_metrics.metrics);
            
            % Extract the x axis metric
            switch cfg.metric_x
                case 'snr-input'
                    output.data(i,1) = out.metrics{1}.snrdb;
                    output.label_x = 'Input SNR (dB)';
                    
                case 'inr-input'
                    output.data(i,1) = out.metrics{1}.inrdb;
                    output.label_x = 'Input INR (dB)';
                    
                otherwise
                    error('unknown metric %s', cfg.metric_x);
            end
            
            % Extract the y axis metric
            switch cfg.metric_y
                case 'snr-beamformer-output'
                    output.data(i,1+m) = out.metrics{2}.snrdb;
                    output.label_y = 'Output SNR (dB)';
                    
                case 'sinr-beamformer-output'
                    output.data(i,1+m) = out.metrics{2}.sinrdb;
                    output.label_y = 'Output SINR (dB)';
                    
                case 'isnr-beamformer-output'
                    output.data(i,1+m) = out.metrics{2}.isnrdb;
                    output.label_y = 'Output ISNR (dB)';
                    
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