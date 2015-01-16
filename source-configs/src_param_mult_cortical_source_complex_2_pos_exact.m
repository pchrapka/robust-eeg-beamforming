%% Source parameter file
% Complex cortical source
%
% Similar to mult_cort_src_complex_1_pos_exact 
% except the exact same waveform


sim_cfg.source_name = 'mult_cort_src_complex_2_pos_exact';

% SNR calculation
% sim_cfg.snr.type = 'per_trial';
sim_cfg.snr.type = 'on_average';
sim_cfg.snr.signal = -10; % in dB
% sim_cfg.snr.interference = 8; % in dB

%% Source 1
sim_cfg.sources{1}.type = 'signal';
sim_cfg.sources{1}.signal_type = 'erp_complex';
sim_cfg.sources{1}.snr = -10; % in dB
sim_cfg.sources{1}.amp = 1;
sim_cfg.sources{1}.minfreq = 4;
sim_cfg.sources{1}.maxfreq = 16;
sim_cfg.sources{1}.pos = 120;
sim_cfg.sources{1}.n_sinusoids = 4;

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
sim_cfg.sources{2}.type = 'signal';
sim_cfg.sources{2}.signal_type = 'erp_complex';
sim_cfg.sources{2}.snr = -10; % in dB
sim_cfg.sources{2}.amp = -1;
sim_cfg.sources{2}.minfreq = 4;
sim_cfg.sources{2}.maxfreq = 16;
sim_cfg.sources{2}.pos = 120;
sim_cfg.sources{2}.n_sinusoids = 4;

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