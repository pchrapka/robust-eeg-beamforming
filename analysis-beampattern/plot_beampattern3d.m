function plot_beampattern3d(cfg)
%PLOT_BEAMPATTERN3D plots beampattern data overlayed on cortex surface
%   PLOT_BEAMPATTERN3D plots beampattern data overlayed on the cortex
%   surface
%
%   cfg.files
%       (cell array) filenames of beampattern data
%   cfg.head        
%       head model cfg (see hm_get_data);
%
%   cfg.options
%   cfg.options.scale
%       colormap scale, options:
%       absolute    0   - MAX
%       relative    MIN - MAX (default)
%       globalabsolute    0   - MAX, over all data
%       globalrelative    MIN - MAX, over all data
%
%   See also COMPUTE_BEAMPATTERN

%% Set defaults
if ~isfield(cfg, 'options'),    cfg.options = [];   end

%% Load the head model
data_in = hm_get_data(cfg.head);
head = data_in.head;
clear data_in;

%% Load the tesselated data
bstdir = brainstorm.bstcust_getdir('db');
fprintf('Loading surface file:\n\t%s\n', head.SurfaceFile);
tess = load(fullfile(bstdir,...
    'Protocol-Phil-BEM','anat',head.SurfaceFile));

%% Data options
tess.data_alpha = 0;
% Data limit
switch(cfg.options.scale)
    case {'relative','absolute'}
        % Do later
    case {'globalrelative','globalabsolute'}
        % Process data to determine global min and max
        % Load the data
        beampattern_data = cell(length(cfg.files));
        for i=1:length(cfg.files)
            din = load(cfg.files{i});
            beampattern_data{i} = din.data.beampattern;
        end
        [y_min, y_max] = lumberjack.get_data_limit(beampattern_data);
        clear beampattern_data;
        % Set the relative by default
        tess.data_limit = [y_min y_max];
        if isequal(cfg.options.scale,'globalabsolute')
            % Adjust if absolute is required
            tess.data_limit = [0 y_max];
        end

    otherwise
        error(['reb:' mfilename],...
            'unknown scale type %s', options.scale);
end

%% Plot data
% Get number of data sets
n_plots = length(cfg.files);
for i=1:n_plots
    % Load the data
    din = load(cfg.files{i});
    beampattern_data = din.data.beampattern;
    
    % Data limit
    switch(cfg.options.scale)
        case 'relative'
            tess.data_limit = [min(beampattern_data) max(beampattern_data)];
        case 'absolute'
            tess.data_limit = [0 max(beampattern_data)];
        case {'globalrelative','globalabsolute'}
            % Already done
        otherwise
            error(['reb:' mfilename],...
                'unknown scale type %s', options.scale);
    end
    
    % Plot the 3D beampattern
    % FIXME Move out of brainstorm package
    brainstorm.bstcust_plot_surface3d_data(tess, beampattern_data);
    
    figname = strrep(din.data.name, '_', ' ');
    set(gcf,'name',figname);%,'numbertitle','off')
end

end