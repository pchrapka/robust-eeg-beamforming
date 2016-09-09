%% Source parameter file
% Multiple cortical sources
% Temporally correlated, but different source locations
%
% Goal:
% Same as mult_cort_src_6, but we want to see if we can separate both
% sources if we eliminate the jitter.


sim_cfg.source_name = 'mult_cort_src_7';


%% Source 1
% Source signal params for pr_peak()
sim_cfg.sources{1}.type = 'signal';
sim_cfg.sources{1}.signal_type = 'erp';
sim_cfg.sources{1}.snr = -10; % in dB
sim_cfg.sources{1}.amp = 2;
sim_cfg.sources{1}.freq = 10;
sim_cfg.sources{1}.pos = 120;
sim_cfg.sources{1}.jitter = 0;

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
sim_cfg.sources{2}.signal_type = 'erp';
sim_cfg.sources{2}.snr = -10; % in dB
sim_cfg.sources{2}.freq = 10;
sim_cfg.sources{2}.pos = 125;
sim_cfg.sources{2}.jitter = 0;

% Source head model params
% Index of brain source voxel
sim_cfg.sources{2}.source_index = 137;

% Source dipole params
% Get a normal dipole orientation
cfg = [];
cfg.head = sim_cfg.head;
cfg.idx = sim_cfg.sources{2}.source_index;
sim_cfg.sources{2}.moment = aet_sim_dipole_orientation(cfg)'; 

%% Noise parameters
sim_cfg.noise_power = 1;
