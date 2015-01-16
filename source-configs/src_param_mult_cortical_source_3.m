%% Source parameter file
% Multiple cortical sources
%
% Based on Ravan2013
%   Second source is 8 dB, 4 Hz, and has a different moment

sim_cfg.source_name = 'mult_cort_src_3';

% Specific beamformer parameter based on sources
sim_cfg.n_interfering_sources = 1;

% SNR calculation
% sim_cfg.snr.type = 'per_trial';
sim_cfg.snr.type = 'on_average';
sim_cfg.snr.signal = -10; % in dB
sim_cfg.snr.interference = 8; % in dB

%% Source 1
% Source signal params for pr_peak()
sim_cfg.sources{1}.type = 'signal';
sim_cfg.sources{1}.signal_type = 'erp';
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

%% Source 2
% Source signal params for pr_peak()
sim_cfg.sources{2} = sim_cfg.sources{1}; % Copy the first source
sim_cfg.sources{2}.type = 'interference';
sim_cfg.sources{2}.signal_type = 'erp';
sim_cfg.sources{2}.snr = 8; % in dB
sim_cfg.sources{2}.freq = 4;
sim_cfg.sources{2}.pos = 200;
sim_cfg.sources{2}.jitter = 5;

sim_cfg.sources{2}.moment = [0.5;0.5;1]/norm([0.5;0.5;1]); 

% Source head model params
% Index of brain source voxel
sim_cfg.sources{2}.source_index = 384;

%% Noise parameters
sim_cfg.noise_amp = 0.1;
sim_cfg.noise_power = 1;