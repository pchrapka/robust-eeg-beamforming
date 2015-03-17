function plot_beampattern_diff(cfg)
%PLOT_BEAMPATTERN_DIFF plots difference in 1D beampattern data
%   PLOT_BEAMPATTERN_DIFF plots difference in beampattern data against the
%   distance between each vertex and the vertex of interest
%
%   cfg.filea
%       filename of beampattern data A
%   cfg.fileb
%       filename of beampattern data B
%   cfg.db
%       (optional, default = true) convert data to db
%   cfg.normalize
%       (optional, default = true) normalize data by the value at vertex of
%       interest
%
%   See also COMPUTE_BEAMPATTERN

% Set defaults
if ~isfield(cfg, 'normalize'),  cfg.normalize = true;   end
if ~isfield(cfg, 'db'),         cfg.db = true;          end

% Load the data
dina = load(cfg.filea);
dinb = load(cfg.fileb);

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

% Plot
plot(data(:,1),data(:,2));

% Format axis
xlim([0 data(end,1)]);

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