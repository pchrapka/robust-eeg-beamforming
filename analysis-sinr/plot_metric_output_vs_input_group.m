function plot_metric_output_vs_input_group(sim,source,beamformers,locations,varargin)

p = inputParser();
addRequired(p,'sim',@(x) ~isempty(x) && ischar(x));
addRequired(p,'source',@(x) ~isempty(x) && ischar(x));
addRequired(p,'beamformers',@(x) ~isempty(x) && iscell(x));
addRequired(p,'location',@(x) ~isempty(x) && isvector(x) && length(x) == 1);
addParameter(p,'matched',true,@islogical);
addParameter(p,'iteration',1,@(x) isvector(x) && length(x) == 1);
addParameter(p,'snrs',-20:0:20,@isvector);
addParameter(p,'metricx','',@(x) ~isempty(x));
addParameter(p,'metricy','',@(x) ~isempty(x));
addParameter(p,'savetag','',@ischar);
addParameter(p,'force',false,@islogical);
parse(p,sim,source,beamformers,locations,varargin{:});

cfg = [];
cfg.force = p.Results.force;
cfg.save_fig = true;
cfg.beam_cfgs = p.Results.beamformers;

% Set up simulation info
cfg.data_set.sim_name = p.Results.sim;
cfg.data_set.source_name = p.Results.source;
cfg.data_set.snr = '';
cfg.data_set.iteration = p.Results.iteration;
cfg.snrs = p.Results.snrs;

if p.Results.matched
    cfg.save_tag = 'matched';
else
    cfg.save_tag = 'mismatched';
end
cfg.save_tag = [cfg.save_tag p.Results.savetag];

% Set up metric
cfg.metric_x = p.Results.metricx;
cfg.metric_y = p.Results.metricy;
cfg.metrics.location_idx = p.Results.location;

% Compute SINR
cfg = compute_metric_output_vs_input(cfg);

% Plot SINR
plot_metric_output_vs_input(cfg);


end
