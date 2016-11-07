%% Plot high res beampatterns using brainstorm functions
%% NOTE Use beampattern_report instead

%% Options
sim_name = 'sim_data_bemhd_1_100t_1000s';
voxel_idx = 5440;
% voxel_idx = 13841;

%% Visualize the beampattern
source_name = 'mult_cort_src_17hd';
cfg = [];
cfg.import = true;
cfg.beamformer_file = fullfile('output',sim_name,...
    source_name,'0_1_lcmv_3sphere.mat');
cfg.voxel_idx = voxel_idx;
vis_beampattern(cfg);

% cfg = [];
% cfg.import = true;
% cfg.beamformer_file = fullfile('output',sim_name,...
%     source_name,'0_1_lcmv.mat');
% % cfg.voxel_idx = 295;
% cfg.voxel_idx = 400;
% vis_beampattern(cfg);

% cfg = [];
% cfg.import = true;
% cfg.beamformer_file = fullfile('output',sim_name,...
%     source_name,'0_1_rmv_aniso_3sphere.mat');
% % cfg.voxel_idx = 295;
% cfg.voxel_idx = 400;
% vis_beampattern(cfg);
% 
% %% Differences
% 
% cfg = [];
% cfg.import = true;
% cfg.beamformer_file = fullfile('output',sim_name,...
%     source_name,'0_1_rmv_aniso_3sphere.mat');
% cfg.beamformer_file_2 = fullfile('output',sim_name,...
%     source_name,'0_1_lcmv_3sphere.mat');
% cfg.voxel_idx = 295;
% % cfg.voxel_idx = 400;
% vis_beampattern(cfg);

%% Close all plots
% brainstorm.bstcust_plot_close();
