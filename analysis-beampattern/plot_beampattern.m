function plot_beampattern(cfg)
%PLOT_BEAMPATTERN plots 1D beampattern data
%   PLOT_BEAMPATTERN plots beampattern data against the distance
%   between each vertex and the vertex of interest
%
%   cfg.file
%       filename of beampattern data
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

% Plot
figure;
plot(data(:,1),data(:,2));

% Format axis
xlim([0 data(end,1)]);
ylim_cur = ylim;
ylim([0 ylim_cur(2)]);

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