%% rms_single_paper

%% Update AET, just in case
update_aet()

%% Initialize the Advanced EEG Toolbox
aet_init

%% Set common parameters
sample_idx = 250*0.460;
true_peak_idx = [295 400];
snr = '0';
clustering = false;

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
cfg.sim_name = 'sim_data_bem_100_100t';
cfg.source_name = 'mult_cort_src_10';
cfg.snr = snr;
cfg.iterations = 1:100;
cfg.head.type = 'brainstorm';
cfg.head.file = 'head_Default1_bem_500V.mat';
cfg.source_type = 'mult';
cfg.cluster = clustering;

%% Calculate the rms
result = rms.rms_bf_configs_iterations(cfg);
% Save the results
rms.rms_save(cfg, result);

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
    ...'rmv_eig_post_0_epsilon_150_3sphere',...
    ...'rmv_eig_post_0_epsilon_200_3sphere',...
    ...'rmv_aniso_eig_0_3sphere',...
    'lcmv_3sphere',...
    'lcmv_eig_1_3sphere',...
    'lcmv_reg_eig_3sphere'};

% Set up simulation info
cfg.sim_name = 'sim_data_bem_100_100t';
cfg.source_name = 'mult_cort_src_10';
cfg.snr = snr;
cfg.iterations = 1:100;
cfg.head.type = 'brainstorm';
cfg.head.file = 'head_Default1_3sphere_500V.mat';
cfg.source_type = 'mult';
cfg.cluster = clustering;

%% Calculate the rms
result = rms.rms_bf_configs_iterations(cfg);
% Save the results
rms.rms_save(cfg, result);