function plot_metric_output_vs_input_group(data_set,beamformers,locations,varargin)

p = inputParser();
addRequired(p,'data_set',@(x) isa(x,'SimDataSetEEG'));
addRequired(p,'beamformers',@(x) ~isempty(x) && iscell(x));
addRequired(p,'location',@(x) ~isempty(x) && isvector(x) && length(x) == 1);
addParameter(p,'matched',true,@islogical);
addParameter(p,'snrs',-20:0:20,@isvector);
addParameter(p,'metricx','',@(x) ~isempty(x));
addParameter(p,'metricy','',@(x) ~isempty(x));
addParameter(p,'savetag','',@ischar);
addParameter(p,'force',false,@islogical);
parse(p,data_set,beamformers,locations,varargin{:});

cfg = [];
cfg.force = p.Results.force;
cfg.save_fig = true;
cfg.beam_cfgs = p.Results.beamformers;

% Set up simulation info
cfg.data_set = p.Results.data_set;
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
