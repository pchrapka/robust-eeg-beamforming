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

output(length(cfg.beam_cfgs)).bf_name = '';
%% Calculate rms for all desired beamformer configs
for i=1:length(cfg.beam_cfgs)
    
    % Save some data
    output(i).data_set = cfg.data_set;
    output(i).bf_name = cfg.beam_cfgs{i};
    
    % Load data
    cfg_data = cfg.data_set;
    
    % Load eeg data
    eeg_data_file = db.save_setup(cfg_data);
    eeg_data_in = load(eeg_data_file);
    cfg_data.tag = cfg.beam_cfgs{i};
    
    % Load bf data
    bf_data_file = db.save_setup(cfg_data);
    bf_data_in = load(bf_data_file);
    
    % Loop through metric configs
    output(i).metrics(length(cfg.metrics)).name = '';
    for j=1:length(cfg.metrics)
        % If a field is a metric run that metric
        metric_cfg = cfg.metrics(j);
        metric = metric_cfg.name;
        switch metric
            case 'snr'
                cfg_snr = [];
                % Extract W from beamformer data
                cfg_snr.W = ...
                    bf_data_in.source.filter{metric_cfg.location_idx};
                
                % Extract S and N from original data
                cfg_snr.S = eeg_data_in.data.avg_signal;
                cfg_snr.N = eeg_data_in.data.avg_noise;
                
                % Save the config
                output(i).metrics(j).name = metric_cfg.name;
                output(i).metrics(j).location_idx = metric_cfg.location_idx;
                output(i).metrics(j).output = metrics.snr(cfg_snr);
                
            otherwise
                error('metrics:run_metrics_on_files',...
                    ['unrecognized metric: ' metric]);
        end

    end
end

end