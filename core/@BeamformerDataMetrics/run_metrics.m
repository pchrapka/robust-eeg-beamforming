function [output] = run_metrics(obj,metrics,varargin)
%   Metrics
%   -------
%   metrics
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

p = inputParser();
addParameter(p,'force',false,@islogical);
parse(p,varargin{:});

obj.load_data('metricsdata');

output.data_set = obj.dataset;
output.bf_name = obj.beamformer;
output.metrics{length(metrics),1}.name = '';

% Loop through metric configs
for j=1:length(metrics)
    
    % if we're forcing a recomputation
    if ~p.Results.force
        % check if metrics already exist
        [flag,idx] = obj.exist_metric(metrics{j});
        if flag
            print_msg_filename(obj.bfdata_file,sprintf('Found %s for',metrics{j}.name));
            output.metrics{j} = obj.metricsdata{idx};
            continue;
        end
    end
    
    print_msg_filename(obj.bfdata_file,sprintf('Working on %s for',metrics{j}.name));
    obj.load_data('eegdata');
    obj.load_data('bfdata');
    
    % convert metric params
    metrics_cpy = rmfield(metrics{j},'name');
    metric_params = lumberjack.struct2namevalue(metrics_cpy);
    
    % create fhandle for metric function
    metric_func_name = strrep(metrics{j}.name,'-','_');
    metric_func = str2func(sprintf('@metric_%s',metric_func_name));
    
    % computer metric
    result = metric_func(obj,metric_params{:});
    result.name = metrics{j}.name;
    
    obj.add_metric(result);
    output.metrics{j} = result;
    
%         case 'rmse'
%             
%             % Get the beamformer output
%             metric_cfg.bf_out = bf_data_in.source.beamformer_output;
%             % Get the beamformer input
%             metric_cfg.bf_in = eeg_data_in.data.avg_dipole_signal;
%             
%             % Select data based on criteria
%             output_select = metrics.rmse_select(metric_cfg);
%             cfg_rmse.bf_out = output_select.bf_out_select';
%             cfg_rmse.input = output_select.bf_in_select';
%             
%             % Calculate the metric
%             output.metrics(j).name = metric_cfg.name;
%             output.metrics(j).location_idx = metric_cfg.location_idx;
%             output.metrics(j).sample_idx = metric_cfg.sample_idx;
%             output.metrics(j).output = metrics.rmse(cfg_rmse);
    

end

obj.save();

end