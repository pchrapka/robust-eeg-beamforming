function plot_power3d(hm,datafile,cfg)
%PLOT_POWER3D plots beamformerer output power data overlayed on cortex surface
%   PLOT_POWER3D plots beamformer output power data overlayed on the cortex
%   surface
%
%   hm
%       IHeadModel object, see HeadModel
%   datafile
%       filename of beamformer output data, as computed by COMPUTE_BEAMPATTERN
%
%   cfg.options
%   cfg.options.samples
%       sample indices to plot, default=1
%       if a vector is specified the average power is plotted
%   cfg.options.scale
%       colormap scale, standard options:
%       absolute        0   - MAX
%       relative        MIN - MAX (default)
%
%       custom scale include your own scale
%       cfg.options.scale = name of scale,
%       cfg.options.data_limit = [ymin ymax]

%% Set defaults
if ~isfield(cfg, 'options'),        cfg.options = [];               end
if ~isfield(cfg.options, 'scale'),  cfg.options.scale = 'relative'; end
if ~isfield(cfg.options, 'samples'), cfg.options.samples = 1;         end

%% Load the data
din = load(datafile);
power_data = din.data.power(:,cfg.options.samples);
if size(power_data,2) > 1
    power_data = mean(power_data,2);
end

%% Load the tesselated data
bstdir = brainstorm.bstcust_getdir('db');
fprintf('Loading surface file:\n\t%s\n', hm.data.SurfaceFile);
tess = load(fullfile(bstdir,...
    'Protocol-Phil-BEM','anat',hm.data.SurfaceFile));
% FIXME Move surface file to head models dir
fprintf('**** FIXME move to head-models project and change in head models file\n');

%% Data options
% Data limit
switch(cfg.options.scale)
    case 'relative'
        tess.data_limit = [min(power_data) max(power_data)];
    case 'absolute'
        tess.data_limit = [0 max(power_data)];
    otherwise % custom
        tess.data_limit = cfg.options.data_limit;
end
% Data alpha
tess.data_alpha = 0;
% Set NaNs to zero avoids problem in BlendAnatomyData
power_data(isnan(power_data)) = 0;

%% Plot the 3D beampattern
% FIXME Move out of brainstorm package
brainstorm.bstcust_plot_surface3d_data(tess, power_data);


%% Format the figure
figname = strrep(din.data.name, '_', ' ');
set(gcf,'name',figname);%,'numbertitle','off')

end