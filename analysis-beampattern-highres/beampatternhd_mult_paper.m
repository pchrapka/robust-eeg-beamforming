%% beampatternhd_mult_paper

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ==== FIRST SOURCE ==== %%
voxel_idx = 5440;
interference_idx = 13841;
snr = '0';

%% ==== MATCHED LEADFIELD ====
%% Set up the config
cfg = [];
% Sample index for beampattern calculation
cfg.voxel_idx = voxel_idx;
if ~isempty(interference_idx)
    cfg.interference_idx = interference_idx;
end

% Set up beamformer data sets to process
cfg.beam_cfgs = {...
    'rmv_epsilon_20',...
    ...'rmv_epsilon_50',...
    ...'rmv_eig_post_0_epsilon_20',...
    ...'rmv_eig_post_0_epsilon_50',...
    'lcmv',...
    'lcmv_eig_1',...
    'lcmv_reg_eig'...
    }; 

% Set up simulation info
cfg.sim_name = 'sim_data_bemhd_1_100t';
cfg.source_name = 'mult_cort_src_17hd';
cfg.snr = snr;
cfg.iteration = '1';
cfg.head.type = 'brainstorm';
cfg.head.file = 'head_Default1_bem_15028V.mat';

%% Plot the beampattern
beampattern_line_bf_file(cfg);
title(['Mult src index ' num2str(voxel_idx)]);

%% ==== MISMATCHED LEADFIELD ====
%% Set up the config
cfg = [];
% Sample index for beampattern calculation
cfg.voxel_idx = voxel_idx;
if ~isempty(interference_idx)
    cfg.interference_idx = interference_idx;
end

% Set up beamformer data sets to process
cfg.beam_cfgs = {...
    ...'rmv_epsilon_50_3sphere',...
    ...'rmv_epsilon_100_3sphere',...
    'rmv_epsilon_150_3sphere',...
    ...'rmv_epsilon_200_3sphere',...
    'rmv_aniso_3sphere',...
    ...'rmv_eig_post_0_epsilon_50_3sphere',...
    ...'rmv_eig_post_0_epsilon_100_3sphere',...
    ...'rmv_eig_post_0_epsilon_150_3sphere',...
    ...'rmv_eig_post_0_epsilon_200_3sphere',...
    ...'rmv_aniso_eig_0_3sphere',...
    'lcmv_3sphere',...
    'lcmv_eig_1_3sphere',...
    'lcmv_reg_eig_3sphere'};

% Set up simulation info
cfg.sim_name = 'sim_data_bemhd_1_100t';
cfg.source_name = 'mult_cort_src_17hd';
cfg.snr = snr;
cfg.iteration = '1';
cfg.head.type = 'brainstorm';
cfg.head.file = 'head_Default1_bem_15028V.mat';

%% Plot the beampattern
beampattern_line_bf_file(cfg);
title(['Mult src index ' num2str(voxel_idx) ' mismatched']);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% ==== SECOND SOURCE ==== %%
% 
% voxel_idx = 400;
% interference_idx = 295;
% snr = '0';
% 
% %% ==== MATCHED LEADFIELD ====
% %% Set up the config
% cfg = [];
% % Sample index for beampattern calculation
% cfg.voxel_idx = voxel_idx;
% cfg.interference_idx = interference_idx;
% 
% % Set up beamformer data sets to process
% cfg.beam_cfgs = {...
%     'rmv_epsilon_20',...
%     ...'rmv_epsilon_50',...
%     ...'rmv_eig_post_0_epsilon_20',...
%     ...'rmv_eig_post_0_epsilon_50',...
%     'lcmv',...
%     'lcmv_eig_1',...
%     'lcmv_reg_eig'...
%     }; 
% 
% % Set up simulation info
% cfg.sim_name = 'sim_data_bem_1_100t';
% cfg.source_name = 'mult_cort_src_10';
% cfg.snr = snr;
% cfg.iteration = '1';
% cfg.head.type = 'brainstorm';
% cfg.head.file = 'head_Default1_bem_500V.mat';
% 
% %% Plot the beampattern
% beampattern_line_bf_file(cfg);
% title(['Mult src index ' num2str(voxel_idx)]);
% 
% %% ==== MISMATCHED LEADFIELD ====
% %% Set up the config
% cfg = [];
% % Sample index for beampattern calculation
% cfg.voxel_idx = voxel_idx;
% cfg.interference_idx = interference_idx;
% 
% % Set up beamformer data sets to process
% cfg.beam_cfgs = {...
%     ...'rmv_epsilon_50_3sphere',...
%     ...'rmv_epsilon_100_3sphere',...
%     'rmv_epsilon_150_3sphere',...
%     ...'rmv_epsilon_200_3sphere',...
%     'rmv_aniso_3sphere',...
%     ...'rmv_eig_post_0_epsilon_50_3sphere',...
%     ...'rmv_eig_post_0_epsilon_100_3sphere',...
%     ...'rmv_eig_post_0_epsilon_150_3sphere',...
%     ...'rmv_eig_post_0_epsilon_200_3sphere',...
%     ...'rmv_aniso_eig_0_3sphere',...
%     'lcmv_3sphere',...
%     'lcmv_eig_1_3sphere',...
%     'lcmv_reg_eig_3sphere'};
% 
% % Set up simulation info
% cfg.sim_name = 'sim_data_bem_1_100t';
% cfg.source_name = 'mult_cort_src_10';
% cfg.snr = snr;
% cfg.iteration = '1';
% cfg.head.type = 'brainstorm';
% cfg.head.file = 'head_Default1_3sphere_500V.mat';
% 
% %% Plot the beampattern
% beampattern_line_bf_file(cfg);
% title(['Mult src index ' num2str(voxel_idx) ' mismatched']);