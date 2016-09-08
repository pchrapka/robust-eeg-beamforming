%% sim_data_bem_1_100t_noavg

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
hmfactory = HeadModel();
sim_cfg.head = hmfactory.createHeadModel('brainstorm','head_Default1_bem_500V.mat');

% Figure out number of channels
gain_temp = sim_cfg.head.get_leadfield(1);
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
sim_cfg.snr_range = 0;%-20:10:20; %-40:5:25; % in dB

% Option for averaged data
sim_cfg.average_data = false;
sim_cfg.keep_trials = true;

%% Extra options
% sim_cfg.force = true;
% sim_cfg.debug = true;
