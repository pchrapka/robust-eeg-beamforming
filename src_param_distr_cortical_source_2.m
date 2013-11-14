%% Source parameter file
% Distributed cortical source
% Temporally correlated, but spread over a few grid points
% Uses a template signal for all the sources

sim_Cfg.force = true; % ===== forcing another analysis ======
sim_cfg.source_name = 'distr_cort_src_2';

% Specific beamformer parameter based on sources
sim_cfg.snr_range = -40:5:25; % in dB

% SNR calculation
% sim_cfg.snr.type = 'per_trial';
sim_cfg.snr.type = 'on_average';
sim_cfg.snr.signal = -10; % in dB
% sim_cfg.snr.interference = 8; % in dB

%% Set up sources
radius = 4/100; % 4 cm
cfg = [];
cfg.head = sim_cfg.head;
cfg.type = 'radius';
cfg.center_idx = 295;
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
cfg.idx = 295;
[~,center_loc] = hm_get_vertices(cfg);
sigma = radius/3; % 3 std devs to be within the radius
spatial_cov = (sigma^2)*ones(1,3);

% Create a template signal so all the waveforms are the same
source_params.amp = 2;
source_params.freq = 10;
source_params.pos = 120;
source_params.jitter = 5;
signal = source_params.amp * pr_peak(...
    sim_cfg.timepoints, 1, sim_cfg.fsample,...
    source_params.freq, source_params.pos, source_params.jitter);

for i=1:length(distr_idx)
    % Source signal params for pr_peak()
    sim_cfg.sources{i}.type = 'signal';
    sim_cfg.sources{i}.signal_type = 'signal';
    sim_cfg.sources{i}.snr = -10; % in dB
    sim_cfg.sources{i}.signal = signal*gauss_distr(...
        distr_loc(i,:),center_loc,spatial_cov);
    %disp(['Amp Source ' num2str(i)]);
    %disp(max(sim_cfg.sources{i}.signal));
    
    % Source dipole params
    sim_cfg.sources{i}.moment = distr_orient(i,:)';
    
    % Source head model params
    % Index of brain source voxel
    sim_cfg.sources{i}.source_index = distr_idx(i);
end

%% Noise parameters
sim_cfg.noise_amp = 0.1;
sim_cfg.noise_power = 1;

%% Clear unnecessary variables
var_list = who;
for i=1:length(var_list)
    if ~isequal(var_list{i},'sim_cfg')
        clear(var_list{i});
    end
end
clear var_list i