function plot_sinr_mult_config_paper(sim_file,source_name,varargin)

p = inputParser();
addRequired(p,'sim_file',@ischar);
addRequired(p,'source_name',@ischar);
addParameter(p,'PlotGroups',{'matched-paper','mismatched-paper'},@iscell);
addParameter(p,'snrs',-10:5:30,@isvector);
addParameter(p,'onaverage',true,@islogical);
addParameter(p,'trial_idx',0,@isvector);
addParameter(p,'data_idx',[],@(x) isempty(x) || isvector(x));
addParameter(p,'datatag','locs2_covtime',@ischar);
parse(p,sim_file,source_name,varargin{:});

%% Get param configs
force = true;
params = [];

for i=1:length(p.Results.PlotGroups)
    if isempty(params)
        params = get_plot_group(p.Results.PlotGroups{i}, p.Results.datatag);
    else
        params(i) = get_plot_group(p.Results.PlotGroups{i}, p.Results.datatag);
    end
end

%% Plots
for i=1:length(params)
    data_set = SimDataSetEEG(...
        sim_file,...
        source_name,...
        0,...
        'iter',1);
    
    % compute metrics all at once
    for j=1:length(params(i).beamformer_configs)
        for k=1:length(p.Results.snrs)
            metrics_avg.average = p.Results.onaverage;
            metrics_avg.trial_idx = p.Results.trial_idx;
            metrics_avg.data_idx = p.Results.data_idx;
            
            metrics = [];
            metrics{1} = metrics_avg;
            metrics{1}.name = 'snr-input';
            metrics{2} = metrics_avg;
            metrics{2}.name = 'sinr-beamformer-output';
            metrics{2}.location_idx = 295;
            metrics{3} = metrics_avg;
            metrics{3}.name = 'snr-beamformer-output';
            metrics{3}.location_idx = 295;
            metrics{4} = metrics_avg;
            metrics{4}.name = 'isnr-beamformer-output';
            metrics{4}.location_idx = 400;
            temp_dataset = SimDataSetEEG(...
                sim_file,...
                source_name,...
                p.Results.snrs(k),...
                'iter',1);
            bdm = BeamformerDataMetrics(temp_dataset,params(i).beamformer_configs{j});
            bdm.run_metrics(metrics);
        end
    end
    
    % signal location, oSINR vs iSNR
    plot_metric_output_vs_input_group(...
        data_set,...
        params(i).beamformer_configs,...
        295,...
        params(i).datatag,...
        'savetag',params(i).tag,...
        'matched',params(i).matched,...
        'metricx','snr-input',...
        'metricy','sinr-beamformer-output',...
        'onaverage',p.Results.onaverage,...
        'trial_idx',p.Results.trial_idx,...
        'data_idx',p.Results.data_idx,...
        'snrs',p.Results.snrs,...
        'force',force...
        );
    
    % signal location, oSNR vs iSNR
    plot_metric_output_vs_input_group(...
        data_set,...
        params(i).beamformer_configs,...
        295,...
        params(i).datatag,...
        'savetag',params(i).tag,...
        'matched',params(i).matched,...
        'metricx','snr-input',...
        'metricy', 'snr-beamformer-output',...
        'onaverage',p.Results.onaverage,...
        'trial_idx',p.Results.trial_idx,...
        'data_idx',p.Results.data_idx,...
        'snrs',p.Results.snrs,...
        'force',force...
        );
    
    % interference location, oISNR vs iSNR
    plot_metric_output_vs_input_group(...
        data_set,...
        params(i).beamformer_configs,...
        400,...
        params(i).datatag,...
        'savetag',params(i).tag,...
        'matched',params(i).matched,...
        'metricx','snr-input',...
        'metricy','isnr-beamformer-output',...
        'onaverage',p.Results.onaverage,...
        'trial_idx',p.Results.trial_idx,...
        'data_idx',p.Results.data_idx,...
        'snrs',p.Results.snrs,...
        'force',force...
        );
end
