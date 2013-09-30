%% Source parameter file
% Single cortical source

sim_cfg.source_name = 'single_cort_src';
sim_cfg.snr_range = -25:1:5; % in dB

% Specific beamformer parameter
sim_cfg.n_interfering_sources = 0;

% SNR calculation
% sim_cfg.snr.type = 'per_trial';
sim_cfg.snr.type = 'on_average';
sim_cfg.snr.signal = -10; % in dB
sim_cfg.snr.interference = 30; % in dB

%% Source 1
% Source signal params for pr_peak()
sim_cfg.sources{1}.type = 'signal';
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
sim_cfg.noise_power = 1;