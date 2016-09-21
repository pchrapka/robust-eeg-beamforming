function plot_beampattern_diff(datafile,cfg)
%PLOT_BEAMPATTERN_DIFF plots difference in 1D beampattern data
%   PLOT_BEAMPATTERN_DIFF plots difference in beampattern data against the
%   distance between each vertex and the vertex of interest
%
%   datafile
%       filename of beampattern data A
%   cfg.diff_file
%       filename of beampattern data B
%   cfg.db
%       (optional, default = true) convert data to db
%   cfg.normalize
%       (optional, default = true) normalize data by the value at vertex of
%       interest
%   cfg.scale
%       data scale for y axis, standard options:
%       absolute        0   - MAX
%       relative        MIN - MAX (default)
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
dina = load(datafile);
dinb = load(cfg.diff_file);

% Check if the distances match
if ~isequal(dina.data.distances, dinb.data.distances)
    error(['rmb:' mfilename],...
        'distances do not match');
end

% Get the data
distances = dina.data.distances;
beampattern_data = dina.data.beampattern - dinb.data.beampattern;

figure;

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
plot(data(:,1),data(:,2));

%% Format plot
% Data limit
switch(cfg.scale)
    case 'relative'
        data_limit = [min(beampattern_data) max(beampattern_data)];
    case 'absolute'
        data_limit = [0 max(beampattern_data)];
    otherwise % custom
        data_limit = cfg.data_limit;
end

% Format axis
xlim([0 data(end,1)]);
ylim(data_limit);

% Format axis labels
figname = [dina.data.name ' - ' dinb.data.name];
figname = strrep(figname, '_', ' ');
title(figname);
xlabel('Distance from source');

% Add line representing location of the interfering source
if isfield(dina.data.options,'interference_dist')
    dist = dina.data.options.interference_dist;
    y = ylim();
    x = [dist dist];
    line(x,y,'color','black');
end
% legend(h, mag_dist_data.name);


end