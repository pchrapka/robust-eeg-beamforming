%% Source parameter file
% Distributed cortical source
% Temporally correlated, but spread over a few grid points


sim_cfg.source_name = 'distr_cort_src_1';

% Specific beamformer parameter based on sources
sim_cfg.snr_range = -40:5:25; % in dB

% SNR calculation
% sim_cfg.snr.type = 'per_trial';
sim_cfg.snr.type = 'on_average';
sim_cfg.snr.signal = -10; % in dB
% sim_cfg.snr.interference = 8; % in dB

%% Set up sources
radius = 2/100;
cfg = [];
cfg.head = sim_cfg.head;
cfg.type = 'radius';
cfg.center_idx = 207;
cfg.radius = radius;
[distr_idx,distr_loc] = hm_get_vertices(cfg);

% Get the dipole orientation, normal to the cortex surface
cfg = [];
cfg.head = sim_cfg.head;
cfg.idx = distr_idx;
distr_orient = dipole_orientation(cfg);

cfg = [];
cfg.head = sim_cfg.head;
cfg.type = 'index';
cfg.idx = 207;
[~,center_loc] = hm_get_vertices(cfg);
sigma = radius*ones(3,1);
for i=1:length(distr_idx)
    % Source signal params for pr_peak()
    sim_cfg.sources{i}.type = 'signal';
    sim_cfg.sources{i}.signal_type = 'erp';
    sim_cfg.sources{i}.snr = -10; % in dB
    sim_cfg.sources{i}.amp = 2*mvnpdf(...
        distr_loc(i),center_loc,sigma);
    disp(['Amp Source ' num2str(i)]);
    disp(sim_cfg.sources{i}.amp);
    sim_cfg.sources{i}.freq = 10;
    sim_cfg.sources{i}.pos = 120;
    sim_cfg.sources{i}.jitter = 5;
    
    % Source dipole params
    sim_cfg.sources{i}.moment = distr_orient(i,:)';
    % This would represent just x direction
    
    % Source head model params
    % Index of brain source voxel
    sim_cfg.sources{i}.source_index = distr_idx(i);
end
clear distr_idx distr_orient cfg sigma cneter_loc

%% Noise parameters
sim_cfg.noise_amp = 0.1;
sim_cfg.noise_power = 1;