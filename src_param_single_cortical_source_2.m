%% Source parameter file
% Single cortical source
%
% Goal: 
% Tests the second source used in mult_cort_src_11, to see if we can
% localize it using the robust beamformers
%
% Warning:
% RMVB doesn't seem to be able to pick up this location. Interesting


sim_cfg.source_name = 'single_cort_src_2';

% Specific beamformer parameter based on sources
sim_cfg.snr_range = -10:10:0; % in dB

% SNR calculation
% sim_cfg.snr.type = 'per_trial';
sim_cfg.snr.type = 'on_average';
sim_cfg.snr.signal = -10; % in dB
% sim_cfg.snr.interference = 8; % in dB

%% Source 1
% Source signal params for pr_peak()
sim_cfg.sources{1}.type = 'signal';
sim_cfg.sources{1}.signal_type = 'erp';
sim_cfg.sources{1}.snr = -10; % in dB
sim_cfg.sources{1}.amp = 2;
sim_cfg.sources{1}.freq = 10;
sim_cfg.sources{1}.pos = 126;
sim_cfg.sources{1}.jitter = 5;

% Source head model params
% Index of brain source voxel
sim_cfg.sources{1}.source_index = 147;

% Source dipole params
% Get a normal dipole orientation
cfg = [];
cfg.head = sim_cfg.head;
cfg.idx = sim_cfg.sources{1}.source_index;
sim_cfg.sources{1}.moment = dipole_orientation(cfg)'; 

%% Noise parameters
sim_cfg.noise_amp = 0.1;
sim_cfg.noise_power = 1;