%% Source parameter file
% Multiple cortical sources
% Temporally correlated, but different source locations


sim_cfg.source_name = 'mult_cort_src_4';


%% Source 1
% Source signal params for pr_peak()
sim_cfg.sources{1}.type = 'signal';
sim_cfg.sources{1}.signal_type = 'erp';
sim_cfg.sources{1}.snr = -10; % in dB
sim_cfg.sources{1}.amp = 2;
sim_cfg.sources{1}.freq = 10;
sim_cfg.sources{1}.pos = 120;
sim_cfg.sources{1}.jitter = 5;

% Source dipole params
sim_cfg.sources{1}.moment = [1;0;0]; 
% This would represent just x direction

% Source head model params
% Index of brain source voxel
sim_cfg.sources{1}.source_index = 207;

%% Source 2
% Source signal params for pr_peak()
sim_cfg.sources{2} = sim_cfg.sources{1}; % Copy the first source
sim_cfg.sources{2}.type = 'signal';
sim_cfg.sources{2}.signal_type = 'erp';
sim_cfg.sources{2}.snr = -10; % in dB
sim_cfg.sources{2}.freq = 10;
sim_cfg.sources{2}.pos = 120;
sim_cfg.sources{2}.jitter = 5;

sim_cfg.sources{2}.moment = [0.5;0.5;1]/norm([0.5;0.5;1]); 

% Source head model params
% Index of brain source voxel
sim_cfg.sources{2}.source_index = 384;

%% Noise parameters
sim_cfg.noise_power = 1;
