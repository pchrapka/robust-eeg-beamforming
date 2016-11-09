function plot_metric_output_vs_input_group(data_set,beamformers,locations,datatag,varargin)

p = inputParser();
addRequired(p,'data_set',@(x) isa(x,'SimDataSetEEG'));
addRequired(p,'beamformers',@(x) ~isempty(x) && iscell(x));
addRequired(p,'location',@(x) ~isempty(x) && isvector(x) && length(x) == 1);
addRequired(p,'datatag',@ischar);
addParameter(p,'matched',true,@islogical);
addParameter(p,'snrs',-20:0:20,@isvector);
addParameter(p,'metricx','',@(x) ~isempty(x));
addParameter(p,'metricy','',@(x) ~isempty(x));
addParameter(p,'onaverage',true,@islogical);
addParameter(p,'trial_idx',0,@isvector);
addParameter(p,'data_idx',[],@(x) isempty(x) || isvector(x));
addParameter(p,'savetag','',@ischar);
addParameter(p,'force',false,@islogical);
parse(p,data_set,beamformers,locations,datatag,varargin{:});

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
cfg.data_tag = p.Results.datatag;

% Set up metric
cfg.metric_x = p.Results.metricx;
cfg.metric_y = p.Results.metricy;
cfg.metrics.location_idx = p.Results.location;
cfg.metrics.average = p.Results.onaverage;
cfg.metrics.trial_idx = p.Results.trial_idx;
cfg.metrics.data_idx = p.Results.data_idx;

% Compute SINR
cfg = compute_metric_output_vs_input(cfg);

% Plot SINR
plot_metric_output_vs_input(cfg);


end
