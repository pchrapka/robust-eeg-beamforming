%% Update AET, just in case
update_aet()

%% Initialize the Advanced EEG Toolbox
aet_init

%% Visualize the beampattern
% cfg = [];
% cfg.import = true;
% cfg.beamformer_file = ['output\sim_data_bem_1_100t\'...
%     'single_cort_src_1\0_1_lcmv_3sphere.mat'];
% cfg.voxel_idx = 295;
% vis_beampattern(cfg);

cfg = [];
cfg.import = true;
cfg.beamformer_file = ['output\sim_data_bem_1_100t\'...
    'single_cort_src_1\0_1_lcmv.mat'];
cfg.voxel_idx = 295;
vis_beampattern(cfg);

cfg = [];
cfg.import = true;
cfg.beamformer_file = ['output\sim_data_bem_1_100t\'...
    'single_cort_src_1\0_1_rmv_aniso_3sphere.mat'];
cfg.voxel_idx = 295;
vis_beampattern(cfg);

%% Visualize the beampattern
cfg = [];
cfg.import = true;
cfg.beamformer_file = ['output\sim_data_bem_1_100t\'...
    'mult_cort_src_10\0_1_lcmv_3sphere.mat'];
% cfg.voxel_idx = 295;
cfg.voxel_idx = 400;
vis_beampattern(cfg);

% cfg = [];
% cfg.import = true;
% cfg.beamformer_file = ['output\sim_data_bem_1_100t\'...
%     'mult_cort_src_10\0_1_lcmv.mat'];
% % cfg.voxel_idx = 295;
% cfg.voxel_idx = 400;
% vis_beampattern(cfg);

cfg = [];
cfg.import = true;
cfg.beamformer_file = ['output\sim_data_bem_1_100t\'...
    'mult_cort_src_10\0_1_rmv_aniso_3sphere.mat'];
% cfg.voxel_idx = 295;
cfg.voxel_idx = 400;
vis_beampattern(cfg);

%% Differences

cfg = [];
cfg.import = true;
cfg.beamformer_file = ['output\sim_data_bem_1_100t\'...
    'mult_cort_src_10\0_1_rmv_aniso_3sphere.mat'];
cfg.beamformer_file_2 = ['output\sim_data_bem_1_100t\'...
    'mult_cort_src_10\0_1_lcmv_3sphere.mat'];
cfg.voxel_idx = 295;
% cfg.voxel_idx = 400;
vis_beampattern(cfg);

%% Close all plots
% brainstorm.bstcust_plot_close();