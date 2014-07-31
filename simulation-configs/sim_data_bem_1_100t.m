%% Parameter file
sim_cfg.sim_name = mfilename; % Get current file name
% optional field for extra naming flexibility
% FIXME Instead of this consider adding an output file field to the
% simulation args, something like how the PSOM bricks are structured
sim_cfg.save_data_files = false;
sim_cfg.out_dir = 'output';
sim_cfg.verbosity = 3;
sim_cfg.parallel = 'user';

%% Head model
sim_cfg.head_cfg.type = 'brainstorm';
sim_cfg.head_cfg.file = 'head_Default1_bem_500V.mat';
% Load the head model
aet_output(sim_cfg, 1, 'Loading the head model\n');
data = hm_get_data(sim_cfg.head_cfg);
sim_cfg.head = data.head;
clear data;

% Figure out number of channels
gain_temp = aet_source_get_gain(1, sim_cfg.head);
sim_cfg.n_channels = size(gain_temp,1);

%% Simulation parameters

% Number of trials
sim_cfg.trials = 100;
% Sampling frequency
sim_cfg.fsample = 250;
% Number of time samples per trial
sim_cfg.timepoints = 1000;
% Simulation runs
sim_cfg.n_runs = 1;
% SNR range
sim_cfg.snr_range = 0;%-10:10:0; %-40:5:25; % in dB

% Option for averaged data
sim_cfg.average_data = true;
sim_cfg.keep_trials = false;

%% Extra options
% sim_cfg.force = true;
% sim_cfg.debug = true;
