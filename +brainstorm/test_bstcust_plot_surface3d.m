%% test_bstcust_plot_surface3d

%% Load the tesselated data
bstdir = brainstorm.bstcust_getdir('db');
tess = load(fullfile(bstdir,...
    'Protocol-Phil-BEM','anat','Subject01','tess_cortex.mat'));

%% Plot the anatomy
hFig = brainstorm.bstcust_create_figure();
surface_color = [0.6 0.6 0.6];
transparency = 0;
hFig = brainstorm.bstcust_plot_surface3d( hFig,...
    tess.Faces, tess.Vertices, surface_color, transparency);