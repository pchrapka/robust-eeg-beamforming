function plot_beampattern(cfg)
%PLOT_BEAMPATTERN plots 1D beampattern data
%   PLOT_BEAMPATTERN plots beampattern data against the distance
%   between each vertex and the vertex of interest
%
%   cfg.file
%       filename of beampattern data, as computed by COMPUTE_BEAMPATTERN
%   cfg.db
%       (optional, default = true) convert data to db
%   cfg.normalize
%       (optional, default = true) normalize data by the value at vertex of
%       interest
%   cfg.scale
%       data scale for y axis, standard options:
%       absolute        0   - MAX
%       relative        MIN - MAX (default)
%       relative-dist   MIN - MAX of closest 25% of vertices
%       mad             MIN - median + multiple*(mean absolute deviation)
%           cfg.mad_multiple specifies the multiple
%
%       custom scale
%       cfg.scale = name of scale,
%       cfg.data_limit = [ymin ymax]
%
%   See also COMPUTE_BEAMPATTERN

% Set defaults
if ~isfield(cfg, 'normalize'),  cfg.normalize = true;   end
if ~isfield(cfg, 'db'),         cfg.db = true;          end
if ~isfield(cfg, 'scale'),      cfg.scale = 'relative'; end

% Load the data
din = load(cfg.file);
distances = din.data.distances;
beampattern_data = din.data.beampattern;

% Combine the data
data = [distances(:) beampattern_data(:)];
% Sort data based on distance
data = sortrows(data,1);

% Adjust data
if cfg.db
    data(:,2) = db(data(:,2));
end
if cfg.normalize
    data(:,2) = data(:,2)/data(1,2);
end

%% Plot
figure;
plot(data(:,1),data(:,2));

%% Format plot
% Data limit
switch(cfg.scale)
    case 'relative'
        data_limit = [min(beampattern_data) max(beampattern_data)];
    case 'mad'
        % Get the median
        data_median = median(beampattern_data);
        % Get the mean absolute median
        data_mad = mad(beampattern_data,1);
        % Calculate the max threshold
        data_max = data_median + cfg.mad_multiple*data_mad;
        data_limit = [min(beampattern_data) data_max];
    case 'relative-dist'
        % Calculate 25% of the largest distance
        dist_min = 0.25*max(distances);
        % Count the number of distances
        npoints = sum(distances < dist_min);
        % Get max from sorted beampattern data that corresponds to the
        % points in the 25th percentile of distances from the source
        data_max = max(data(1:npoints,2));
        data_limit = [min(beampattern_data) data_max];
    case 'absolute'
        data_limit = [0 max(beampattern_data)];
    otherwise % custom
        data_limit = cfg.data_limit;
end

% Format axis
xlim([0 data(end,1)]);
ylim(data_limit);

% Format axis labels
ystr = strrep(din.data.name, '_', ' ');
ylabel(ystr);
xlabel('Distance from source');

% Add line representing location of the interfering source
if isfield(din.data.options,'interference_dist')
    dist = din.data.options.interference_dist;
    y = ylim();
    x = [dist dist];
    line(x,y,'color','black');
end


end