%% Source parameter file
% Multiple cortical sources
% Different source locations, peaks occur at slightly different time points
% Dipoles are not both normal to the cortex
% Sinusoidal sources
%
% Goal:
% Explore the effect sinusoidal sources on RMSE performance. The
% configuration is the same and mult_cort_src_17 except with two sinusoidal
% sources instead of ERPs.
% This is also a variation on mult_cort_src_sine_2, the sinusoids differ by
% pi/2 making them uncorrelated

% sim_cfg.force = true;

sim_cfg.source_name = 'mult_cort_src_sine_2_uncor';


%% Source 1
% Source signal params for pr_peak()
sim_cfg.sources{1}.type = 'signal';
sim_cfg.sources{1}.signal_type = 'sine';
sim_cfg.sources{1}.snr = -10; % in dB
sim_cfg.sources{1}.amp = 2;
sim_cfg.sources{1}.freq = 10;
sim_cfg.sources{1}.phase = 0;
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
sim_cfg.sources{2}.type = 'interference';
sim_cfg.sources{2}.signal_type = 'sine';
sim_cfg.sources{2}.snr = -10; % in dB
sim_cfg.sources{2}.freq = 10;
sim_cfg.sources{2}.phase = pi/2;
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
sim_cfg.noise_power = 1;
