%% Source parameter file
% Distributed cortical source
% Temporally correlated, but spread over a few grid points
% Uses a template signal for all the sources

% sim_cfg.force = true; % ===== forcing another analysis ======
sim_cfg.source_name = 'distr_cort_src_3';


%% Set up sources
center_idx = 295;
radius = 4/100; % 4 cm

sigma = radius/3; % 3 std devs to be within the radius
spatial_cov = (sigma^2)*ones(1,3);

sim_cfg.sources{1}.radius = radius;
sim_cfg.sources{1}.center_idx = center_idx;
sim_cfg.sources{1}.spatial_cov = spatial_cov;
sim_cfg.sources{1}.moment = [1 1 0]'/norm([1 1 0]);
sim_cfg.sources{1}.correlated = 'no';

sim_cfg.sources{1}.type = 'signal';
sim_cfg.sources{1}.signal_type = 'erp_distributed';
sim_cfg.sources{1}.snr = '-10';
sim_cfg.sources{1}.amp = 2;
sim_cfg.sources{1}.freq = 10;
sim_cfg.sources{1}.pos = 120;
sim_cfg.sources{1}.jitter = 5;


%% Noise parameters
sim_cfg.noise_power = 1;
