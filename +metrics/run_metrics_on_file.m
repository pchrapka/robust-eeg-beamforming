function [output] = run_metrics_on_file(cfg)
%
%   Beamformer Config
%   -----------------
%   cfg.beam_cfg   (string) beamformer cfg file tag to process
%
%     Example: 
%     cfg.beam_cfg = 'rmv_epsilon_20';
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
%
%   INR
%   name = 'inr'
%   location_idx
%       location index for INR calculation
%
%   SINR
%   name = 'sinr'
%   location_idx
%       location index for SINR calculation
%   flip (boolean, default = false)
%       switches signal and interference signals, allows SINR calculation
%       from perspective of the interference signal
%
%   RMSE
%   name = 'rmse'
%   location_idx
%       location index for RMSE calculation
%   sample_idx
%       sample index for RMSE calculation


if isfield(cfg, 'data_set')
    % Save some data
    output.data_set = cfg.data_set;
    % Load data
    cfg_data = cfg.data_set;
    
    % Load eeg data
    eeg_data_file = db.save_setup(cfg_data);
    eeg_data_in = load(eeg_data_file);
end

if isfield(cfg, 'beam_cfg')
    % Save some data
    output.bf_name = cfg.beam_cfg;
    cfg_data.tag = cfg.beam_cfg;
    % Load bf data
    bf_data_file = db.save_setup(cfg_data);
    bf_data_in = load(bf_data_file);
end

% Loop through metric configs
output.metrics(length(cfg.metrics)).name = '';
for j=1:length(cfg.metrics)
    % If a field is a metric run that metric
    metric_cfg = cfg.metrics(j);
    metric = metric_cfg.name;
    
    % Set defaults
    if isfield(metric_cfg, 'flip')
        error('flip field is deprecated, please use isnr');
    end
            
    switch metric
        case 'vdist'
            cfg_vert = [];
            % Set up params for vertex_distances
            cfg_vert.head = metric_cfg.head;
            cfg_vert.voi_idx = metric_cfg.voi_idx;
            cfg_vert.location_idx = metric_cfg.location_idx;
            
            % Save info
            output.metrics(j).name = metric_cfg.name;
            output.metrics(j).location_idx = metric_cfg.location_idx;
            output.metrics(j).voi_idx = metric_cfg.voi_idx;
            % Calculate the metric
            output.metrics(j).output = metrics.vertex_distances(cfg_vert);
            
        case 'snr'
            cfg_snr = [];
            % Extract W from beamformer data
            cfg_snr.W = ...
                bf_data_in.source.filter{metric_cfg.location_idx};
            
            % Extract S and N from original data
            cfg_snr.S = eeg_data_in.data.avg_signal;
            cfg_snr.N = eeg_data_in.data.avg_noise;
            
            % Save info
            output.metrics(j).name = metric_cfg.name;
            output.metrics(j).location_idx = metric_cfg.location_idx;
            % Calculate the metric
            output.metrics(j).output = metrics.snr(cfg_snr);
            
        case 'inr'
            cfg_inr = [];
            % Extract W from beamformer data
            cfg_inr.W = ...
                bf_data_in.source.filter{metric_cfg.location_idx};
            
            % Extract S and N from original data
            cfg_inr.I = eeg_data_in.data.avg_interference;
            cfg_inr.N = eeg_data_in.data.avg_noise;
            
            % Save info
            output.metrics(j).name = metric_cfg.name;
            output.metrics(j).location_idx = metric_cfg.location_idx;
            % Calculate the metric
            output.metrics(j).output = metrics.inr(cfg_inr);
            
        case 'sinr'
            cfg_sinr = [];
            % Extract W from beamformer data
            idx_w = bf_data_in.source.loc == metric_cfg.location_idx;
            cfg_sinr.W = ...
                bf_data_in.source.filter{idx_w};
            if length(size(cfg_sinr.W)) > 2
                if size(cfg_sinr.W,1) > 1
                    error('not implemented for mutliple time points');
                else
                    cfg_sinr.W = squeeze(cfg_sinr.W);
                end
            end
            
            % Extract S, I and N from original data
            cfg_sinr.S = eeg_data_in.data.avg_signal;
            cfg_sinr.I = eeg_data_in.data.avg_interference;
            cfg_sinr.N = eeg_data_in.data.avg_noise;
            
            % Save info
            output.metrics(j).name = metric_cfg.name;
            output.metrics(j).location_idx = metric_cfg.location_idx;
            % Calculate the metric
            output.metrics(j).output = metrics.sinr(cfg_sinr);
            
        case 'isnr'
            
            cfg_sinr = [];
            % Extract W from beamformer data
            idx_w = bf_data_in.source.loc == metric_cfg.location_idx;
            cfg_sinr.W = ...
                bf_data_in.source.filter{idx_w};
            if length(size(cfg_sinr.W)) > 2
                if size(cfg_sinr.W,1) > 1
                    error('not implemented for mutliple time points');
                else
                    cfg_sinr.W = squeeze(cfg_sinr.W);
                end
            end
            
            % Extract S, I and N from original data
            cfg_sinr.I = eeg_data_in.data.avg_interference;
            cfg_sinr.S = eeg_data_in.data.avg_signal;
            cfg_sinr.N = eeg_data_in.data.avg_noise;
            
            % Save info
            output.metrics(j).name = metric_cfg.name;
            output.metrics(j).location_idx = metric_cfg.location_idx;
            % Calculate the metric
            output.metrics(j).output = metrics.isnr(cfg_sinr);
            
        case 'inputsnr'
            
            % Calculate snr from data as well
            snrdb = aet_analysis_snr(...
                eeg_data_in.data.avg_signal,...
                eeg_data_in.data.avg_noise);
            
            % Save info
            output.metrics(j).name = metric_cfg.name;
            output.metrics(j).output.snrdb = snrdb;
            
        case 'inputinr'
            
            % Calculate snr from data as well
            inrdb = aet_analysis_snr(...
                eeg_data_in.data.avg_interference,...
                eeg_data_in.data.avg_noise);
            
            % Save info
            output.metrics(j).name = metric_cfg.name;
            output.metrics(j).output.inrdb = inrdb;
            
        case 'rmse'
            
            % Get the beamformer output
            metric_cfg.bf_out = bf_data_in.source.beamformer_output;
            % Get the beamformer input
            metric_cfg.bf_in = eeg_data_in.data.avg_dipole_signal;
            
            % Select data based on criteria
            output_select = metrics.rmse_select(metric_cfg);
            cfg_rmse.bf_out = output_select.bf_out_select';
            cfg_rmse.input = output_select.bf_in_select';
            
            % Calculate the metric
            output.metrics(j).name = metric_cfg.name;
            output.metrics(j).flip = metric_cfg.flip;
            output.metrics(j).location_idx = metric_cfg.location_idx;
            output.metrics(j).sample_idx = metric_cfg.sample_idx;
            output.metrics(j).output = metrics.rmse(cfg_rmse);
            
            
        otherwise
            error('metrics:run_metrics_on_files',...
                ['unrecognized metric: ' metric]);
    end
    
end

end