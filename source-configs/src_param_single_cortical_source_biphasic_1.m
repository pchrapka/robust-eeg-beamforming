%% Source parameter file
% Similar to single_cort_src_complex_1 except
% Biphasic ERP


sim_cfg.source_name = 'single_cort_src_biphasic_1';


%% Source 1
% Source signal params for pr_peak()
sim_cfg.sources{1}.type = 'signal';
sim_cfg.sources{1}.signal_type = 'erp_biphasic';
sim_cfg.sources{1}.snr = -10; % in dB
sim_cfg.sources{1}.amp1 = 1;
sim_cfg.sources{1}.freq1 = 7;
sim_cfg.sources{1}.pos1 = 115;
sim_cfg.sources{1}.amp2 = -1;
sim_cfg.sources{1}.freq2 = 12;
sim_cfg.sources{1}.pos2 = 126;
sim_cfg.sources{1}.jitter = 3;

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
