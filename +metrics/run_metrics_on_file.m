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
            % Set defaults
            if ~isfield(metric_cfg, 'flip')
                metric_cfg.flip = false; 
            end
            
            cfg_sinr = [];
            % Extract W from beamformer data
            cfg_sinr.W = ...
                bf_data_in.source.filter{metric_cfg.location_idx};
            
            % Extract S, I and N from original data
            if metric_cfg.flip
                cfg_sinr.S = eeg_data_in.data.avg_interference;
                cfg_sinr.I = eeg_data_in.data.avg_signal;
            else
                cfg_sinr.S = eeg_data_in.data.avg_signal;
                cfg_sinr.I = eeg_data_in.data.avg_interference;
            end
            cfg_sinr.N = eeg_data_in.data.avg_noise;
            
            % Save info
            output.metrics(j).name = metric_cfg.name;
            output.metrics(j).flip = metric_cfg.flip;
            output.metrics(j).location_idx = metric_cfg.location_idx;
            % Calculate the metric
            output.metrics(j).output = metrics.sinr(cfg_sinr);
            
        case 'rmse'
            % Make sure sample_idx and location_idx are initialized
            if ~isfield(metric_cfg, 'sample_idx')
                metric_cfg.sample_idx = 0;
            end
            if ~isfield(metric_cfg, 'location_idx')
                metric_cfg.location_idx = 0;
            end
            
            % Get the beamformer output
            bf = bf_data_in.source.beamformer_output;
            % Get the beamformer input
            bf_input = eeg_data_in.data.avg_dipole_signal;
            
            % Select the data at the user sample index
            if metric_cfg.sample_idx > 0 && metric_cfg.location_idx > 0
                bf_select = squeeze(bf(:, metric_cfg.location_idx, metric_cfg.sample_idx));
                input_select = squeeze(bf_input(:, metric_cfg.location_idx, metric_cfg.sample_idx));
            elseif metric_cfg.sample_idx > 0
                bf_select = squeeze(bf(:, :, metric_cfg.sample_idx));
                input_select = squeeze(bf_input(:, :, metric_cfg.sample_idx));
            elseif metric_cfg.location_idx > 0
                bf_select = squeeze(bf(:, metric_cfg.location_idx, :));
                input_select = squeeze(bf_input(:, metric_cfg.location_idx, :));
            else
                error('metrics:rmse',...
                    'must specify either sample_idx or location_idx');
            end
            
            cfg_rmse.bf_out = bf_select';
            cfg_rmse.input = input_select';
            
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