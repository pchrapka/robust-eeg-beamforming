function [output] = run_metrics_on_files(cfg)
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
%   cfg.data_set with the following fields
%   sim_name    simulation config name
%   source_name source config name
%   snr         snr
%   iteration   simulation iteration
%
%     Example:
%     cfg.data_set.sim_name = 'sim_data_bem_1_100t';
%     cfg.data_set.source_name = 'mult_cort_src_10';
%     cfg.data_set.snr = 0;
%     cfg.data_set.iteration = '1';
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