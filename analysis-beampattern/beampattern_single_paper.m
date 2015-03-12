%% beampattern_single_paper

voxel_idx = 295;
snr = '0';

%% ==== MATCHED LEADFIELD ====
%% Set up the config
cfg = [];
% Sample index for beampattern calculation
cfg.voxel_idx = voxel_idx;

% Set up beamformer data sets to process
cfg.beam_cfgs = {...
    'rmv_epsilon_20',...
    ...'rmv_epsilon_50',...
    ...'rmv_eig_post_0_epsilon_20',...
    ...'rmv_eig_post_0_epsilon_50',...
    'lcmv',...
    'lcmv_eig_0',...
    'lcmv_reg_eig'...
    }; 

% Set up simulation info
cfg.data_set.sim_name = 'sim_data_bem_1_100t';
cfg.data_set.source_name = 'single_cort_src_1';
cfg.data_set.snr = snr;
cfg.data_set.iteration = '1';
cfg.head.type = 'brainstorm';
cfg.head.file = 'head_Default1_bem_500V.mat';

%% Plot the beampattern
cfg = compute_beampattern(cfg);
cfgplt = [];
cfgplt.files = cfg.outputfile;
plot_beampattern(cfgplt)
cfgplt.head = cfg.head;
plot_beampattern3d(cfgplt);

%% ==== MISMATCHED LEADFIELD ====
%% Set up the config
cfg = [];
% Sample index for beampattern calculation
cfg.voxel_idx = voxel_idx;

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
    'lcmv_eig_0_3sphere',...
    'lcmv_reg_eig_3sphere'};

% Set up simulation info
cfg.data_set.sim_name = 'sim_data_bem_1_100t';
cfg.data_set.source_name = 'single_cort_src_1';
cfg.data_set.snr = snr;
cfg.data_set.iteration = '1';
cfg.head.type = 'brainstorm';
cfg.head.file = 'head_Default1_3sphere_500V.mat';

%% Plot the beampattern
cfg = compute_beampattern(cfg);
cfgplt = [];
cfgplt.files = cfg.outputfile;
plot_beampattern(cfgplt);
cfgplt.head = cfg.head;
plot_beampattern3d(cfgplt);