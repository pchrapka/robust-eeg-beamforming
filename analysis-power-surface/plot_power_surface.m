function plot_power_surface(data_set,beamformers,varargin)

p = inputParser();
addRequired(p,'data_set',@(x) isa(x,'SimDataSetEEG'));
addRequired(p,'beamformers',@(x) ~isempty(x) && iscell(x));
addParameter(p,'source_idx',[],@(x) x > 1 && length(x) == 1);
addParameter(p,'int_idx',[],@(x) x > 1 && length(x) == 1);
addParameter(p,'mode','instant',@(x) any(validatestring(x,{'instant','average'})));
addParameter(p,'sample_idx',[],@(x) x > 1 && length(x) == 1);
addParameter(p,'force',false,@islogical);

parse(p,data_set,beamformers,varargin{:});

%% Set up the config
cfg = [];
cfg.force = p.Results.force;

% Sample index for beampattern calculation
cfg.voxel_idx = p.Results.source_idx;
if ~isempty(p.Results.int_idx)
    cfg.interference_idx = p.Results.int_idx;
end

cfg.data_set = p.Results.data_set;
cfg.beam_cfgs = p.Results.beamformers;

%% Compute the beamformer output power
outputfiles = compute_power(cfg);

%% Plot the surface
cfgview = [];
cfgview.datafiles = outputfiles;
cfgview.data_set = cfg.data_set;
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