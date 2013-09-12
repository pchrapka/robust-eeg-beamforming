%% Parameter file
sim_cfg.sim_name = mfilename; % Get current file name
sim_cfg.save_data_files = false;
sim_cfg.out_dir = 'output';
sim_cfg.verbosity = 3;
sim_cfg.parallel = 'user';
sim_cfg.n_channels = 0;

%% Head model
sim_cfg.head_model_file = 'head_Default1_500V.mat';

%% Simulation parameters

% Number of trials
sim_cfg.trials = 10;
% Sampling frequency
sim_cfg.fsample = 250;
% Number of time samples per trial
sim_cfg.timepoints = 500;
% Simulation runs
sim_cfg.n_runs = 20;

%% Source params

%% Source 1
% Source signal params for pr_peak()
sim_cfg.sources{1}.snr = -10; % in dB
sim_cfg.sources{1}.amp = 2;
sim_cfg.sources{1}.freq = 10;
sim_cfg.sources{1}.pos = 120;
sim_cfg.sources{1}.jitter = 5;

% Source dipole params
sim_cfg.sources{1}.moment = [1;0;0]; 
% This would represent just x direction

% Source head model params
% Index of brain source voxel
sim_cfg.sources{1}.source_index = 207;

%% Noise parameters
sim_cfg.noise_amp = 0.1;

