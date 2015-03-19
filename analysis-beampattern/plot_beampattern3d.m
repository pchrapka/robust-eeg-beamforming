function plot_beampattern3d(cfg)
%PLOT_BEAMPATTERN3D plots beampattern data overlayed on cortex surface
%   PLOT_BEAMPATTERN3D plots beampattern data overlayed on the cortex
%   surface
%
%   cfg.file
%       filename of beampattern data, as computed by COMPUTE_BEAMPATTERN
%   cfg.head        
%       head model cfg (see hm_get_data);
%
%   cfg.options
%   cfg.options.scale
%       colormap scale, standard options:
%       absolute        0   - MAX
%       relative        MIN - MAX (default)
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
data_in = hm_get_data(cfg.head);
head = data_in.head;
clear data_in;

%% Load the tesselated data
bstdir = brainstorm.bstcust_getdir('db');
fprintf('Loading surface file:\n\t%s\n', head.SurfaceFile);
tess = load(fullfile(bstdir,...
    'Protocol-Phil-BEM','anat',head.SurfaceFile));

%% Load the data
din = load(cfg.file);
beampattern_data = din.data.beampattern;

%% Data options
tess.data_alpha = 0;
% Data limit
switch(cfg.options.scale)
    case 'relative'
        tess.data_limit = [min(beampattern_data) max(beampattern_data)];
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