function rms_analysis_iters_single_paper(cfg_in)
%RMS_ANALYSIS_ITERS_SINGLE_PAPER Sets up rms analysis for single source
%data with multiple iterations

% Set common parameters
snr = '0';

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
    'lcmv_reg_eig'...
    }; 

% Set up simulation info
cfg.sim_name = 'sim_data_bem_100_100t';
cfg.source_name = 'single_cort_src_1';
cfg.snr = snr;
cfg.iterations = 1:100;
hmfactory = HeadModel();
cfg.head = hmfactory.createHeadModel('brainstorm', 'head_Default1_bem_500V.mat');
cfg.source_type = 'single';

%% Calculate the rms
result = rms.rms_bf_configs_iterations(cfg);
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
    ...'rmv_epsilon_100_3sphere',...
    'rmv_epsilon_150_3sphere',...
    ...'rmv_epsilon_200_3sphere',...
    'rmv_aniso_3sphere',...
    ...'rmv_eig_post_0_epsilon_50_3sphere',...
    ...'rmv_eig_post_0_epsilon_100_3sphere',...
    ...'rmv_eig_post_0_epsilon_150_3sphere',...
    ...'rmv_eig_post_0_epsilon_200_3sphere',...
    ...'rmv_aniso_eig_0_3sphere',...
    'lcmv_3sphere',...
    'lcmv_eig_0_3sphere',...
    'lcmv_reg_eig_3sphere'};

% Set up simulation info
cfg.sim_name = 'sim_data_bem_100_100t';
cfg.source_name = 'single_cort_src_1';
cfg.snr = snr;
cfg.iterations = 1:100;
hmfactory = HeadModel();
cfg.head = hmfactory.createHeadModel('brainstorm', 'head_Default1_3sphere_500V.mat');
cfg.source_type = 'single';

%% Calculate the rms
result = rms.rms_bf_configs_iterations(cfg);
% Save the results
rms.rms_save(cfg, result);

end