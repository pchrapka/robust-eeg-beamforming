function rms_analysis_iter1_mult_paper(cfg_in)
%RMS_ANALYSIS_ITER1_MULT_PAPER Sets up rms analysis for multiple source
%data with 1 iteration
%
% cfg_in.source_name
%       name of source config
% cfg_in.snr
%       snr value
% cfg_in.sample_idx
%       sample index for calculating rmse
% cfg_in.location_idx
%       location index for calculating rmse

% Set common parameters
snr = cfg_in.snr;
clustering = false;
source_name = cfg_in.source_name;

%% ==== MATCHED LEADFIELD ====
%% Set up the config
cfg = [];
if isfield(cfg_in,'sample_idx')
    % Set sample indicies for rms calculation
    cfg.sample_idx = cfg_in.sample_idx;
end
if isfield(cfg_in,'location_idx')
    % Set location indicies for rms calculation
    cfg.location_idx = cfg_in.location_idx;
end

% Set up beamformer data sets to process
cfg.beam_cfgs = {...
    'rmv_epsilon_20',...
    ...'rmv_epsilon_50',...
    ...'rmv_eig_post_0_epsilon_20',...
    ...'rmv_eig_post_0_epsilon_50',...
    'lcmv',...
    'lcmv_eig_0',...
    'lcmv_eig_1',...
    'lcmv_reg_eig'...
    }; 

% Set up simulation info
cfg.sim_name = 'sim_data_bem_1_100t';
cfg.source_name = source_name;
cfg.snr = snr;
cfg.iteration = '1';
hmfactory = HeadModel();
cfg.head = hmfactory.createHeadModel('brainstorm', 'head_Default1_bem_500V.mat');
cfg.source_type = 'mult';
cfg.cluster = clustering;

%% Calculate the rms
result = rms.rms_bf_files(cfg);
% Save the results
rms.rms_save(cfg, result);

%% ==== MISMATCHED LEADFIELD ====
%% Set up the config
cfg = [];
if isfield(cfg_in,'sample_idx')
    % Set sample indicies for rms calculation
    cfg.sample_idx = cfg_in.sample_idx;
end
if isfield(cfg_in,'location_idx')
    % Set location indicies for rms calculation
    cfg.location_idx = cfg_in.location_idx;
end

% Set up beamformer data sets to process
cfg.beam_cfgs = {...
    ...'rmv_epsilon_50_3sphere',...
    'rmv_epsilon_100_3sphere',...
    'rmv_epsilon_150_3sphere',...
    'rmv_epsilon_200_3sphere',...
    ...'rmv_epsilon_250_3sphere',...
    ...'rmv_epsilon_300_3sphere',...
    'rmv_aniso_3sphere',...
    ...'rmv_eig_post_0_epsilon_50_3sphere',...
    ...'rmv_eig_post_0_epsilon_100_3sphere',...
    ....'rmv_eig_post_0_epsilon_150_3sphere',...
    ...'rmv_eig_post_0_epsilon_200_3sphere',...
    ...'rmv_aniso_eig_0_3sphere',...
    'lcmv_3sphere',...
    'lcmv_eig_0_3sphere',...
    'lcmv_eig_1_3sphere',...
    'lcmv_reg_eig_3sphere'};

% Set up simulation info
cfg.sim_name = 'sim_data_bem_1_100t';
cfg.source_name = source_name;
cfg.snr = snr;
cfg.iteration = '1';
hmfactory = HeadModel();
cfg.head = hmfactory.createHeadModel('brainstorm', 'head_Default1_3sphere_500V.mat');
cfg.source_type = 'mult';
cfg.cluster = clustering;

%% Calculate the rms
result = rms.rms_bf_files(cfg);
% Save the results
rms.rms_save(cfg, result);
end