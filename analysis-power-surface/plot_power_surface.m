function plot_power_surface(sim,source,beamformers,varargin)

p = inputParser();
addRequired(p,'sim',@(x) ~isempty(x) && ischar(x));
addRequired(p,'source',@(x) ~isempty(x) && ischar(x));
addRequired(p,'beamformers',@(x) ~isempty(x) && iscell(x));
addParameter(p,'snr',0,@(x) length(x) == 1);
addParameter(p,'source_idx',[],@(x) x > 1 && length(x) == 1);
addParameter(p,'int_idx',[],@(x) x > 1 && length(x) == 1);
addParameter(p,'mode','instant',@(x) any(validatestring(x,{'instant','average'})));
addParameter(p,'sample_idx',[],@(x) x > 1 && length(x) == 1);
addParameter(p,'force',false,@islogical);

parse(p,sim,source,beamformers,varargin{:});

%% Set up the config
cfg = [];
cfg.force = p.Results.force;

% Sample index for beampattern calculation
cfg.voxel_idx = p.Results.source_idx;
if ~isempty(p.Results.int_idx)
    cfg.interference_idx = p.Results.int_idx;
end

% Set up simulation info
cfg.data_set.sim_name = p.Results.sim;
cfg.data_set.source_name = p.Results.source;
cfg.data_set.snr = p.Results.snr;
cfg.data_set.iteration = 1;

% TODO get from source data
% if matched
%     hmfactory = HeadModel();
%     cfg.head = hmfactory.createHeadModel('brainstorm', 'head_Default1_bem_15028V.mat');
% else
%     hmfactory = HeadModel();
%     cfg.head = hmfactory.createHeadModel('brainstorm', 'head_Default1_3sphere_15028V.mat');
% end

cfg.beam_cfgs = p.Results.beamformers;

%% Compute the beamformer output power
cfg = compute_power(cfg);

%% Plot the surface
cfgview = [];
cfgview.datafiles = cfg.outputfile;
cfgview.data_set = cfg.data_set;
cfgview.head = cfg.head; % TODO get from data file
switch p.Results.mode
    case 'instant'
        cfgview.sample = p.Results.sample_idx;
    case 'average'
        if p.Results.sample_idx > 0 
            warning('sample idx is not required when using average power');
        end
        cfgview.sample = [];
end
view_power_surface_relative(cfgview);

end