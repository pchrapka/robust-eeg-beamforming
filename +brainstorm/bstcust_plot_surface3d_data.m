function [hFig] = bstcust_plot_surface3d_data(tess, data)

% % Load the tesselated data
% bstdir = brainstorm.bstcust_getdir('db');
% tess = load(fullfile(bstdir,...
%     'Protocol-Phil-BEM','anat','Subject01','tess_cortex.mat'));

% Get surface color based on data
surface_color = brainstorm.bstcust_get_surfacecolor(tess, data);

% Plot the anatomy
hFig = brainstorm.bstcust_create_figure();
transparency = 0;
hFig = brainstorm.bstcust_plot_surface3d( hFig,...
    tess.Faces, tess.Vertices, surface_color, transparency);

end