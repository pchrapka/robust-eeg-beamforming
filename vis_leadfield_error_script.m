%% Visualize the leadfield errors
cfg = [];
cfg.import = true;
cfg.threshold = 10000;
vis_leadfield_error(cfg);

%% Close all plots
% brainstorm.bstcust_plot_close();