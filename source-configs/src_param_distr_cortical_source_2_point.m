%% Source parameter file
% Distributed cortical source and a point source
% Temporally uncorrelated, but spread over a few grid points
% Uses a template signal for all the sources

% sim_cfg.force = true; % ===== forcing another analysis ======
sim_cfg.source_name = 'distr_cort_src_2_point';

% SNR calculation
% sim_cfg.snr.type = 'per_trial';
sim_cfg.snr.type = 'on_average';
sim_cfg.snr.signal = -10; % in dB
% sim_cfg.snr.interference = 8; % in dB

%% Source 1
center_idx = 295;
radius = 4/100; % 4 cm

sigma = radius/3; % 3 std devs to be within the radius
spatial_cov = (sigma^2)*ones(1,3);

sim_cfg.sources{1}.radius = radius;
sim_cfg.sources{1}.center_idx = center_idx;
sim_cfg.sources{1}.spatial_cov = spatial_cov;
sim_cfg.sources{1}.correlated = 'no';

sim_cfg.sources{1}.type = 'signal';
sim_cfg.sources{1}.signal_type = 'erp_distributed';
sim_cfg.sources{1}.snr = '-10';
sim_cfg.sources{1}.amp = 2;
sim_cfg.sources{1}.freq = 10;
sim_cfg.sources{1}.pos = 120;
sim_cfg.sources{1}.jitter = 5;

%% Source 2
% Source signal params for pr_peak()
sim_cfg.sources{2}.type = 'interference';
sim_cfg.sources{2}.signal_type = 'erp';
sim_cfg.sources{2}.snr = -10; % in dB
sim_cfg.sources{2}.amp = 2;
sim_cfg.sources{2}.freq = 10;
sim_cfg.sources{2}.pos = 124;
sim_cfg.sources{2}.jitter = 5;

% Source head model params
% Index of brain source voxel
sim_cfg.sources{2}.source_index = 400;

% Source dipole params
% Get a normal dipole orientation
cfg = [];
cfg.head = sim_cfg.head;
cfg.idx = sim_cfg.sources{2}.source_index;
sim_cfg.sources{2}.moment = [1 1 0]'/norm([1 1 0]); 


%% Noise parameters
sim_cfg.noise_amp = 0.1;
sim_cfg.noise_power = 1;
