function plot_beampattern3d_diff(hm,datafile,cfg)
%PLOT_BEAMPATTERN3D_DIFF plots difference in beampattern data on cortex
%   PLOT_BEAMPATTERN3D_DIFF plots difference in beampattern data on the cortex
%
%   hm       
%       IHeadModel obj, see HeadModel
%   datafile
%       filename of beampattern data A
%   cfg.diff_file
%       filename of beampattern data B
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

%% Load the head model
hm.load();

%% Load the tesselated data
bstdir = brainstorm.bstcust_getdir('db');
fprintf('Loading surface file:\n\t%s\n', hm.data.SurfaceFile);
tess = load(fullfile(bstdir,...
    'Protocol-Phil-BEM','anat',hm.data.SurfaceFile));

%% Load the data
dina = load(datafile);
dinb = load(cfg.diff_file);

%% Take the difference
beampattern_data = dina.data.beampattern - dinb.data.beampattern;

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

% Set the title
figname = [dina.data.name ' - ' dinb.data.name];
figname = strrep(figname, '_', ' ');
set(gcf,'name',figname);%,'numbertitle','off')

end