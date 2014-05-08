%% rms_mult_paper

sample_idx = 250*0.460;
true_peak_idx = [295 400];
snr = '0';

%% ==== MATCHED LEADFIELD ====
%% Set up the config
cfg = [];
% Sample index for rms calculation
cfg.sample_idx = sample_idx;
% Index of true peak
cfg.true_peak = true_peak_idx;

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
cfg.sim_name = 'sim_data_bem_1_100t';
cfg.source_name = 'mult_cort_src_10';
cfg.snr = snr;
cfg.iteration = '1';
cfg.head.type = 'brainstorm';
cfg.head.file = 'head_Default1_bem_500V.mat';
cfg.cluster = true;

%% Calculate the rms
result = rms_bf_file(cfg);

%% ==== MISMATCHED LEADFIELD ====
%% Set up the config
cfg = [];
% Sample index for rms calculation
cfg.sample_idx = sample_idx;
% Index of true peak
cfg.true_peak = true_peak_idx;

% Set up beamformer data sets to process
cfg.beam_cfgs = {...
    ...'rmv_epsilon_50_3sphere',...
    ...'rmv_epsilon_100_3sphere',...
    'rmv_epsilon_150_3sphere',...
    ...'rmv_epsilon_200_3sphere',...
    'rmv_aniso_3sphere',...
    ...'rmv_eig_post_0_epsilon_50_3sphere',...
    ...'rmv_eig_post_0_epsilon_100_3sphere',...
    ....'rmv_eig_post_0_epsilon_150_3sphere',...
    ...'rmv_eig_post_0_epsilon_200_3sphere',...
    ...'rmv_aniso_eig_0_3sphere',...
    'lcmv_3sphere',...
    'lcmv_eig_1_3sphere',...
    'lcmv_reg_eig_3sphere'};

% Set up simulation info
cfg.sim_name = 'sim_data_bem_1_100t';
cfg.source_name = 'mult_cort_src_10';
cfg.snr = snr;
cfg.iteration = '1';
cfg.head.type = 'brainstorm';
cfg.head.file = 'head_Default1_3sphere_500V.mat';
cfg.cluster = true;
cfg.n_clusters = 2;

%% Calculate the rms
result = rms_bf_file(cfg);