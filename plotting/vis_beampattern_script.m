

%% Options
sim_name = 'sim_data_bem_1_100t';

%% Visualize the beampattern
source_name = 'single_cort_src_1';
% cfg = [];
% cfg.import = true;
% cfg.beamformer_file = fullfile('output',sim_name,...
%     source_name,'0_1_lcmv_3sphere.mat');
% cfg.voxel_idx = 295;
% vis_beampattern(cfg);

cfg = [];
cfg.import = true;
cfg.beamformer_file = fullfile('output',sim_name,...
    source_name,'0_1_lcmv.mat');
cfg.voxel_idx = 295;
vis_beampattern(cfg);

cfg = [];
cfg.import = true;
cfg.beamformer_file = fullfile('output',sim_name,...
    source_name,'0_1_rmv_aniso_3sphere.mat');
cfg.voxel_idx = 295;
vis_beampattern(cfg);

%% Visualize the beampattern
% source_name = 'mult_cort_src_10';
source_name = 'mult_cort_src_17';
cfg = [];
cfg.import = true;
cfg.beamformer_file = fullfile('output',sim_name,...
    source_name,'0_1_lcmv_3sphere.mat');
% cfg.voxel_idx = 295;
cfg.voxel_idx = 400;
vis_beampattern(cfg);

% cfg = [];
% cfg.import = true;
% cfg.beamformer_file = fullfile('output',sim_name,...
%     source_name,'0_1_lcmv.mat');
% % cfg.voxel_idx = 295;
% cfg.voxel_idx = 400;
% vis_beampattern(cfg);

cfg = [];
cfg.import = true;
cfg.beamformer_file = fullfile('output',sim_name,...
    source_name,'0_1_rmv_aniso_3sphere.mat');
% cfg.voxel_idx = 295;
cfg.voxel_idx = 400;
vis_beampattern(cfg);

%% Differences

cfg = [];
cfg.import = true;
cfg.beamformer_file = fullfile('output',sim_name,...
    source_name,'0_1_rmv_aniso_3sphere.mat');
cfg.beamformer_file_2 = fullfile('output',sim_name,...
    source_name,'0_1_lcmv_3sphere.mat');
cfg.voxel_idx = 295;
% cfg.voxel_idx = 400;
vis_beampattern(cfg);

%% Close all plots
% brainstorm.bstcust_plot_close();