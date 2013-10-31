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
sim_cfg.head_model_file = 'head_Default1_500V.mat';

%% Load the head model
aet_output(sim_cfg, 1, 'Loading the head model\n');
sim_cfg.head_model_data_full = fullfile('..','head-models',...
    'brainstorm', sim_cfg.head_model_file);
load(sim_cfg.head_model_data_full);
sim_cfg.head = head;

% Figure out number of channels
gain_temp = aet_source_get_gain(1, sim_cfg.head);
sim_cfg.n_channels = size(gain_temp,1);

%% Simulation parameters

% Number of trials
sim_cfg.trials = 10;
% Sampling frequency
sim_cfg.fsample = 250;
% Number of time samples per trial
sim_cfg.timepoints = 1000;
% Simulation runs
sim_cfg.n_runs = 10;

% Option for averaged data
sim_cfg.average_data = true;
sim_cfg.keep_trials = false;

%% Options for beamformer types
% sim_cfg.beamformer_types = {'lcmv_eig'};
sim_cfg.beamformer_types = {'rmv','lcmv','lcmv_eig','lcmv_reg'};
% sim_cfg.beamformer_types = {'beamspace'};
