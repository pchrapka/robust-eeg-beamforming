%% Source parameter file
% Multiple cortical sources
% Different source locations
% erp 1 = monophasic erp
% erp 2 = biphasic erp
%
% Goal:
% Similar to mult_cort_src 9,10,11 series except we explore a different
% signal for the second source, RMVB was not picking up the second source
% in the previously mentioned scenarios

% sim_cfg.force = true;

sim_cfg.source_name = 'mult_cort_src_12';

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
sim_cfg.sources{2} = sim_cfg.sources{1}; % Copy the first source
sim_cfg.sources{2}.type = 'signal';
sim_cfg.sources{2}.signal_type = 'erp_biphasic';
sim_cfg.sources{2}.snr = -10; % in dB
sim_cfg.sources{2}.amp1 = 2;
sim_cfg.sources{2}.freq1 = 7;
sim_cfg.sources{2}.pos1 = 115;
sim_cfg.sources{2}.amp2 = -2;
sim_cfg.sources{2}.freq2 = 12;
sim_cfg.sources{2}.pos2 = 126;
sim_cfg.sources{2}.jitter = 3;

% Source head model params
% Index of brain source voxel
sim_cfg.sources{2}.source_index = 400;

% Source dipole params
% Get a normal dipole orientation
cfg = [];
cfg.head = sim_cfg.head;
cfg.idx = sim_cfg.sources{2}.source_index;
sim_cfg.sources{2}.moment = aet_sim_dipole_orientation(cfg)'; 

%% Noise parameters
sim_cfg.noise_amp = 0.1;
sim_cfg.noise_power = 1;