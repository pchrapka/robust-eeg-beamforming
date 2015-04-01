function plot_sources3d(cfg)
%PLOT_SOURCES3D plots source markers
%   PLOT_BEAMPATTERN3D plots source markers
%   surface
%
%   cfg.file
%       filename of beampattern data, as computed by COMPUTE_BEAMPATTERN
%   cfg.head        
%       head model cfg (see hm_get_data);
%
%   See also COMPUTE_BEAMPATTERN

%% Load the head model
data_in = hm_get_data(cfg.head);
head = data_in.head;
clear data_in;

%% Load the data
din = load(cfg.file);

%% Plot the source location
% Get the source location
cfgvert = [];
cfgvert.type = 'index';
cfgvert.idx = din.data.options.voxel_idx;
cfgvert.head = head;
[~, loc] = hm_get_vertices(cfgvert);

hold on;
% Plot a black circle
scatter3(loc(1), loc(2), loc(3), 100, [0 0 0], 'filled');

%% Plot the interference location
if isfield(din.data.options, 'interference_idx');
    % Get the interference location
    cfgvert = [];
    cfgvert.type = 'index';
    cfgvert.idx = din.data.options.interference_idx;
    cfgvert.head = head;
    [~, loc] = hm_get_vertices(cfgvert);
    
    hold on;
    % Plot a black x
    scatter3(loc(1), loc(2), loc(3), 100, [0 0 0], 's', 'filled');
end
    

end