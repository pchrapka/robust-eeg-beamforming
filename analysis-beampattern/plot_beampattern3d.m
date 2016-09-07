function plot_beampattern3d(cfg)
%PLOT_BEAMPATTERN3D plots beampattern data overlayed on cortex surface
%   PLOT_BEAMPATTERN3D plots beampattern data overlayed on the cortex
%   surface
%
%   cfg.file
%       filename of beampattern data, as computed by COMPUTE_BEAMPATTERN
%   cfg.head        
%       IHeadModel obj, see HeadModel
%
%   cfg.options
%   cfg.options.scale
%       colormap scale, standard options:
%       absolute        0   - MAX
%       relative        MIN - MAX (default)
%       relative-dist   MIN - MAX of closest 25% of vertices
%       mad             MIN - median + multiple*(mean absolute deviation)
%           cfg.mad_multiple specifies the multiple
%
%       custom scale include your own scale
%       cfg.options.scale = name of scale,
%       cfg.options.data_limit = [ymin ymax]
%
%   See also COMPUTE_BEAMPATTERN

%% Set defaults
if ~isfield(cfg, 'options'),        cfg.options = [];               end
if ~isfield(cfg.options, 'scale'),  cfg.options.scale = 'relative'; end

%% Load the head model
cfg.head.load();

%% Load the tesselated data
bstdir = brainstorm.bstcust_getdir('db');
fprintf('Loading surface file:\n\t%s\n', cfg.head.data.SurfaceFile);
tess = load(fullfile(bstdir,...
    'Protocol-Phil-BEM','anat',cfg.head.data.SurfaceFile));
% FIXME Move surface file to head models dir
fprintf('**** FIXME move to head-models project and change in head models file');

%% Load the data
din = load(cfg.file);
beampattern_data = din.data.beampattern;

%% Data options
tess.data_alpha = 0;
% Data limit
switch(cfg.options.scale)
    case 'relative'
        tess.data_limit = [min(beampattern_data) max(beampattern_data)];
    case 'mad'
        data_median = median(beampattern_data);
        data_mad = mad(beampattern_data,1);
        data_max = data_median + cfg.options.mad_multiple*data_mad;
        tess.data_limit = [min(beampattern_data) data_max];
        beampattern_data(beampattern_data > data_max) = 0;
    case 'relative-dist'
        distances = din.data.distances;
        % Combine the data
        data = [distances(:) beampattern_data(:)];
        % Sort data based on distance
        data = sortrows(data,1);
        % Calculate 25% of the largest distance
        dist_min = 0.25*max(distances);
        % Count the number of distances
        npoints = sum(distances < dist_min);
        % Get max from sorted beampattern data that corresponds to the
        % points in the 25th percentile of distances from the source
        data_max = max(data(1:npoints,2));
        tess.data_limit = [min(beampattern_data) data_max];
        beampattern_data(beampattern_data > data_max) = 0;
    case 'absolute'
        tess.data_limit = [0 max(beampattern_data)];
    otherwise % custom
        tess.data_limit = cfg.options.data_limit;
end

%% Plot the 3D beampattern
% FIXME Move out of brainstorm package
brainstorm.bstcust_plot_surface3d_data(tess, beampattern_data);


%% Format the figure
figname = strrep(din.data.name, '_', ' ');
set(gcf,'name',figname);%,'numbertitle','off')

end