%% Source parameter file
% Multiple cortical sources
% Different source locations, peaks occur at slightly different time points
% Dipoles are not both normal to the cortex
%
% Goal:
% Used to generate beampattern on a high resolution head model. Source
% vertices are the same as mult_cort_src_17, which results in a different
% index.

% sim_cfg.force = true;

sim_cfg.source_name = 'mult_cort_src_17hd';

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
sim_cfg.sources{1}.source_index = 5440;

% Source dipole params
% Get a normal dipole orientation
cfg = [];
cfg.head = sim_cfg.head;
cfg.idx = sim_cfg.sources{1}.source_index;
sim_cfg.sources{1}.moment = aet_sim_dipole_orientation(cfg)'; 

%% Source 2
% Source signal params for pr_peak()
sim_cfg.sources{2} = sim_cfg.sources{1}; % Copy the first source
sim_cfg.sources{2}.type = 'interference';
sim_cfg.sources{2}.signal_type = 'erp';
sim_cfg.sources{2}.snr = -10; % in dB
sim_cfg.sources{2}.freq = 10;
sim_cfg.sources{2}.pos = 124;
sim_cfg.sources{2}.jitter = 5;

% Source head model params
% Index of brain source voxel
sim_cfg.sources{2}.source_index = 13841;

% Source dipole params
% Get a normal dipole orientation
cfg = [];
cfg.head = sim_cfg.head;
cfg.idx = sim_cfg.sources{2}.source_index;
sim_cfg.sources{2}.moment = [1 1 0]'/norm([1 1 0]); 

%% Noise parameters
sim_cfg.noise_amp = 0.1;
sim_cfg.noise_power = 1;