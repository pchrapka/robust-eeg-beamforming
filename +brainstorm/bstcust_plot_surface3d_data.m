function [hFig] = bstcust_plot_surface3d_data(tess, data)
%BSTCUST_PLOT_SURFACE3D_DATA plots data overlayed on cortex surface
%   BSTCUST_PLOT_SURFACE3D_DATA(tess, data) plots data overlayed on cortex
%   surface
%
%   tess
%       tesselated data from surface file
%   data
%       vector containing data to be plotted, [vertices x 1]

% % Load the tesselated data
% bstdir = brainstorm.bstcust_getdir('db');
% tess = load(fullfile(bstdir,...
%     'Protocol-Phil-BEM','anat','Subject01','tess_cortex.mat'));

fprintf('**** FIXME Move output of brainstorm package: %s\n', mfilename);

%% Get surface color based on data
surface_color = brainstorm.bstcust_get_surfacecolor(tess, data);

%% Plot the anatomy
hFig = brainstorm.bstcust_create_figure();
transparency = 0;
hFig = brainstorm.bstcust_plot_surface3d( hFig,...
    tess.Faces, tess.Vertices, surface_color, transparency);

%% Add colorbar
colorbar;
% Set the colormap scale
hAxes = gca;
set(hAxes,'CLim',tess.data_limit);

end