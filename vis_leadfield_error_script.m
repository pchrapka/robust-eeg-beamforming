%% Update AET, just in case
update_aet()

%% Initialize the Advanced EEG Toolbox
aet_init

%% Visualize the leadfield errors
cfg = [];
cfg.import = true;
cfg.threshold = 10000;
vis_leadfield_error(cfg);

%% Close all plots
% brainstorm.bstcust_plot_close();

%% Visualize the leadfield errors with a projection
cfg = [];
cfg.import = true;
cfg.threshold = 10000;
cfg.projection = true;
vis_leadfield_error(cfg);

%% Close all plots
% brainstorm.bstcust_plot_close();