%% Source parameter file
% Distributed cortical source
% Temporally correlated, but spread over a few grid points
% Uses a template signal for all the sources

% sim_cfg.force = true; % ===== forcing another analysis ======
sim_cfg.source_name = 'distr_cort_src_2';

% SNR calculation
% sim_cfg.snr.type = 'per_trial';
sim_cfg.snr.type = 'on_average';
sim_cfg.snr.signal = -10; % in dB
% sim_cfg.snr.interference = 8; % in dB

%% Set up sources
center_idx = 295;
radius = 4/100; % 4 cm
% cfg = [];
% cfg.head = sim_cfg.head;
% cfg.type = 'radius';
% cfg.center_idx = center_idx;
% cfg.radius = radius;
% [distr_idx,distr_loc] = hm_get_vertices(cfg);

% % Get the dipole orientation, normal to the cortex surface
% cfg = [];
% cfg.head = sim_cfg.head;
% cfg.idx = distr_idx;
% distr_orient = aet_sim_dipole_orientation(cfg);

% cfg = [];
% cfg.head = sim_cfg.head;
% cfg.type = 'index';
% cfg.idx = center_idx;
% [~,center_loc] = hm_get_vertices(cfg);
sigma = radius/3; % 3 std devs to be within the radius
spatial_cov = (sigma^2)*ones(1,3);

sim_cfg.sources{1}.radius = radius;
sim_cfg.sources{1}.center_idx = center_idx;
sim_cfg.sources{1}.spatial_cov = spatial_cov;

% % Create a template signal so all the waveforms are the same
% source_params.amp = 2;
% source_params.freq = 10;
% source_params.pos = 120;
% source_params.jitter = 5;
% signal = source_params.amp * pr_peak(...
%     sim_cfg.timepoints, 1, sim_cfg.fsample,...
%     source_params.freq, source_params.pos, source_params.jitter);
% 
% for i=1:length(distr_idx)
%     % Source signal params for pr_peak()
%     sim_cfg.sources{i}.type = 'signal';
%     sim_cfg.sources{i}.signal_type = 'signal';
%     sim_cfg.sources{i}.snr = -10; % in dB
%     sim_cfg.sources{i}.signal = signal*gauss_distr(...
%         distr_loc(i,:),center_loc,spatial_cov);
%     %disp(['Amp Source ' num2str(i)]);
%     %disp(max(sim_cfg.sources{i}.signal));
%     
%     % Source dipole params
%     sim_cfg.sources{i}.moment = distr_orient(i,:)';
%     
%     % Source head model params
%     % Index of brain source voxel
%     sim_cfg.sources{i}.source_index = distr_idx(i);
% end

sim_cfg.sources{1}.type = 'signal';
sim_cfg.sources{1}.signal_type = 'erp_distributed';
sim_cfg.sources{1}.snr = '-10';
sim_cfg.sources{1}.amp = 2;
sim_cfg.sources{1}.freq = 10;
sim_cfg.sources{1}.pos = 120;
sim_cfg.sources{1}.jitter = 5;


%% Noise parameters
sim_cfg.noise_amp = 0.1;
sim_cfg.noise_power = 1;
