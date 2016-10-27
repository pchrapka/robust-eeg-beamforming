%% src_param_s1_randerp_s2_cnoise_neeg

% Source parameter file
% 2 cortical sources
% Different source locations
%
% Goal:
% Explore the effect of an uncorrelated second source

% sim_cfg.force = true;

sim_cfg.source_name = 's1_randerp_s2_cnoise_neeg';


%% Source 1
% Source signal params for pr_peak()
sim_cfg.sources{1}.type = 'signal';
sim_cfg.sources{1}.signal_type = 'erp-random-amplitude';
sim_cfg.sources{1}.snr = -10; % in dB
sim_cfg.sources{1}.amp = 2;
sim_cfg.sources{1}.freq = 10;
sim_cfg.sources{1}.pos = 120;
sim_cfg.sources{1}.jitter = 5;

% Source head model params
% Index of brain source voxel
sim_cfg.sources{1}.source_index = 295;

% Source dipole params
% Get a normal dipole orientation
cfg = [];
cfg.head = sim_cfg.head;
cfg.idx = sim_cfg.sources{1}.source_index;
sim_cfg.sources{1}.moment = aet_sim_dipole_orientation(cfg)'; 

%% Source 2
% Source signal params for pr_peak()
sim_cfg.sources{2}.type = 'interference';
sim_cfg.sources{2}.signal_type = 'colored-noise';
sim_cfg.sources{2}.amp = 2;
sim_cfg.sources{2}.amp_var = 0.1;
sim_cfg.sources{2}.lpf = lpf_filter();

% Source head model params
% Index of brain source voxel
sim_cfg.sources{2}.source_index = 400;

% Source dipole params
% Get a normal dipole orientation
cfg = [];
cfg.head = sim_cfg.head;
cfg.idx = sim_cfg.sources{2}.source_index;
sim_cfg.sources{2}.moment = [1 1 0]'/norm([1 1 0]); 

%% Noise parameters
sim_cfg.noise_power = 1;
sim_cfg.noise_type = 'eeg';
