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

