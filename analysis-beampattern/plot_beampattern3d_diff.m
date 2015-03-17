function plot_beampattern3d_diff(cfg)
%PLOT_BEAMPATTERN3D_DIFF plots difference in beampattern data on cortex
%   PLOT_BEAMPATTERN3D_DIFF plots difference in beampattern data on the cortex
%
%   cfg.filea
%       filename of beampattern data A
%   cfg.fileb
%       filename of beampattern data B
%   cfg.head        
%       head model cfg (see hm_get_data);
%
%   See also COMPUTE_BEAMPATTERN

% Load the head model
data_in = hm_get_data(cfg.head);
head = data_in.head;
clear data_in;

% Load the tesselated data
bstdir = brainstorm.bstcust_getdir('db');
fprintf('Loading surface file:\n\t%s\n', head.SurfaceFile);
tess = load(fullfile(bstdir,...
    'Protocol-Phil-BEM','anat',head.SurfaceFile));

% Load the data
dina = load(cfg.filea);
dinb = load(cfg.fileb);

% Take the difference
beampattern_data = dina.data.beampattern - dinb.data.beampattern;

% Plot the 3D beampattern
% FIXME Move out of brainstorm package
brainstorm.bstcust_plot_surface3d_data(tess, beampattern_data);

% Set the title
figname = [dina.data.name ' - ' dinb.data.name];
figname = strrep(figname, '_', ' ');
set(gcf,'name',figname);%,'numbertitle','off')

end