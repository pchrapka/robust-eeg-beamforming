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
radius = 4/100;
[distr_idx,distr_loc] = sim_cfg.head.get_vertices(...
    'type','radius','center_idx',207,'radius',radius);

% Get the dipole orientation, normal to the cortex surface
cfg = [];
cfg.head = sim_cfg.head;
cfg.idx = distr_idx;
distr_orient = aet_sim_dipole_orientation(cfg);

[~,center_loc] = sim_cfg.head.get_vertices('type','index','idx',207);

sigma = radius/3; % 3 std devs to be within the radius
spatial_cov = (sigma^2)*ones(1,3);
for i=1:length(distr_idx)
    % Source signal params for pr_peak()
    sim_cfg.sources{i}.type = 'signal';
    sim_cfg.sources{i}.signal_type = 'erp';
    sim_cfg.sources{i}.snr = -10; % in dB
    sim_cfg.sources{i}.amp = 2*gauss_distr(...
        distr_loc(i,:),center_loc,spatial_cov);
    %disp(['Amp Source ' num2str(i)]);
    %disp(sim_cfg.sources{i}.amp);
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