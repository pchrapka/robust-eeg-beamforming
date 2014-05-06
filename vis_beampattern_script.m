%% Update AET, just in case
update_aet()

%% Initialize the Advanced EEG Toolbox
aet_init

%% Visualize the leadfield errors
cfg = [];
cfg.import = true;
cfg.beamformer_file = ['output\sim_data_bem_1_100t\'...
    'single_cort_src_1\0_1_rmv_aniso_eig_post_0_3sphere.mat'];
vis_beampattern(cfg);

%% Close all plots
% brainstorm.bstcust_plot_close();