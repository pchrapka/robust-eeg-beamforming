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
%   cfg.data_set 
%       SimDataSetEEG object
%
%   Metrics
%   -------
%   cfg.metrics
%       struct array of metrics to run, each element has a 'name' field and
%       additional fields required for that metric
%
%   SNR - Input
%   name = 'snr-input'
%
%   INR - Input
%   name = 'inr-input'
%
%   SNR - Beamformer Output
%   name = 'snr-beamformer-output'
%   location_idx
%       location index for SNR calculation
%
%   INR - Beamformer Output
%   name = 'inr-beamformer-output'
%   location_idx
%       location index for INR calculation
%
%   SINR - Beamformer Output
%   name = 'sinr-beamformer-output'
%   location_idx
%       location index for SINR calculation
%
%   ISNR - Beamformer Output
%   name = 'isnr-beamformer-output'
%   location_idx
%       location index for SINR calculation
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
    
    % Load eeg data
    eeg_data_file = db.save_setup('data_set',cfg.data_set);
    eeg_data_in = load(eeg_data_file);
end

if isfield(cfg, 'beam_cfg')
    % Save some data
    output.bf_name = cfg.beam_cfg;
    
    % Load bf data
    bf_data_file = db.save_setup('data_set',cfg.data_set,'tag',cfg.beam_cfg);
    bf_data_in = load(bf_data_file);
end

% Loop through metric configs
output.metrics(length(cfg.metrics)).name = '';
for j=1:length(cfg.metrics)
    % If a field is a metric run that metric
    metric_cfg = cfg.metrics(j);
    metric = metric_cfg.name;
    
    print_msg_filename(bf_data_file,sprintf('Working on %s for',metric));
    
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
            
        case 'snr-beamformer-output'            
            % Save info
            output.metrics(j).name = metric_cfg.name;
            output.metrics(j).location_idx = metric_cfg.location_idx;
            
            % Calculate the metric
            output.metrics(j).output = metrics.snr_beamformer_output(...
                eeg_data_in.data.avg_signal,...
            	eeg_data_in.data.avg_noise,...
                get_W(bf_data_in.source, metric_cfg.location_idx));
            
        case 'inr-beamformer-output'
            
            % Calculate the metric
            result = metrics.snr_beamformer_output(...
                eeg_data_in.data.avg_interference,...
            	eeg_data_in.data.avg_noise,...
                get_W(bf_data_in.source, metric_cfg.location_idx));
            
            output.metrics(j).output.inr = result.snr;
            output.metrics(j).output.inrdb = result.snrdb;
            
        case 'sinr-beamformer-output'
            % Save info
            output.metrics(j).name = metric_cfg.name;
            output.metrics(j).location_idx = metric_cfg.location_idx;
            
            % Calculate the metric
            output.metrics(j).output = metrics.sinr_beamformer_output(...
                eeg_data_in.data.avg_signal,...
                eeg_data_in.data.avg_interference,...
                eeg_data_in.data.avg_noise,...
                get_W(bf_data_in.source, metric_cfg.location_idx));
            
        case 'isnr-beamformer-output'
            
            % Calculate the metric
            result = metrics.sinr_beamformer_output(...
                eeg_data_in.data.avg_interference,...
                eeg_data_in.data.avg_signal,...
                eeg_data_in.data.avg_noise,...
                get_W(bf_data_in.source, metric_cfg.location_idx));
            
            output.metrics(j).output.isnr = result.sinr;
            output.metrics(j).output.isnrdb = result.sinrdb;
            
        case 'snr-input'
            
            % Save info
            output.metrics(j).name = metric_cfg.name;
            % Calculate snr from data
            output.metrics(j).output = metrics.snr_input(...
                eeg_data_in.data.avg_signal,...
                eeg_data_in.data.avg_noise);
            
        case 'inr-input'
            
            % Calculate snr from data as well
            result = metrics.snr_input(...
                eeg_data_in.data.avg_interference,...
                eeg_data_in.data.avg_noise);
            
            % Save info
            output.metrics(j).name = metric_cfg.name;
            output.metrics(j).output.inr = result.snr;
            output.metrics(j).output.inrdb = result.snrdb;
            
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
            output.metrics(j).location_idx = metric_cfg.location_idx;
            output.metrics(j).sample_idx = metric_cfg.sample_idx;
            output.metrics(j).output = metrics.rmse(cfg_rmse);
            
            
        otherwise
            error('metrics:run_metrics_on_files',...
                'unrecognized metric: %s', metric);
    end
    
end

end

function W = get_W(source_data, location)
% Extract W from beamformer data
idx_w = source_data.loc == location;
W = source_data.filter(:,idx_w);
if length(size(W{1})) > 2
    if size(W{1},1) > 1
        error('not implemented for mutliple time points');
    end
end
end