function [output] = run_metrics_on_files(cfg)
%RUN_METRICS_ON_FILES runs metrics when multiple beamformer configs are
%specified
%
%   Beamformer Config
%   -----------------
%   cfg.beam_cfgs   cell array of beamformer cfg file tags to process
%
%     Example: 
%     cfg.beam_cfgs = {...
%         'rmv_epsilon_20',...
%         'lcmv'
%         };
%       
%   Data Set
%   --------
%   cfg.data_set 
%       SimDataSetEEG object
%
%   Metrics
%   -------
%   cfg.metrics
%       struct array of metrics to run, each element has a 'name' field and
%       additional fields required for that metric
%
%   SNR
%   name = 'snr'
%   location_idx
%       location index for SNR calculation

%% Calculate rms for all desired beamformer configs
parfor i=1:length(cfg.beam_cfgs)
    
    % Copy the config to avoid warnings
    cfg_copy = cfg;
    % Set the beam cfg
    cfg_copy.beam_cfg = cfg_copy.beam_cfgs{i};
    % Run metrics on the individual file
    output(i) = metrics.run_metrics_on_file(cfg_copy);
end

end