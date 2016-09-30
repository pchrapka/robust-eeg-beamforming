%% src_param_single_cortical_source_sine_2_noise_white

% sim_cfg.force = true;

sim_cfg.source_name = 'single_cort_src_sine_2_noise_white';


%% Source 1
% Source signal params
sim_cfg.sources{1}.type = 'signal';
sim_cfg.sources{1}.signal_type = 'sine';
sim_cfg.sources{1}.snr = -10; % in dB
sim_cfg.sources{1}.amp = 2;
sim_cfg.sources{1}.freq = 10;
sim_cfg.sources{1}.phase = 2*pi/3;
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

%% Noise parameters
sim_cfg.noise_power = 1;
sim_cfg.noise_type = 'white';
