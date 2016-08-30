%% metric_analysis_sinr_single

%% Set up different metrics to calculate
% Single source results with 1 iteration

source_names = {...
    'single_cort_src_1',...
    };
    
snrs = -20:10:20;
location_idx = 1:501;
cfg = [];
cfg.force = false;
% cfg.force = true;
cfg.save_fig = true;

% Loop through source names
for j=1:length(source_names)
    
    %% ==== MATCHED LEADFIELD ====
    % Set up beamformer data sets to process
    beam_cfgs_matched = {...
        'rmv_epsilon_20',...
        ...'rmv_epsilon_50',...
        'rmv_eig_pre_cov_0_epsilon_20',...
        'rmv_eig_post_0_epsilon_20',...
        ...'rmv_eig_post_0_epsilon_50',...
        'lcmv',...
        'lcmv_eig_0',...
        'lcmv_reg_eig'...
        };
    
    cfg.beam_cfgs = beam_cfgs_matched;
    
    % Set up simulation info
    cfg.data_set.sim_name = 'sim_data_bem_1_100t';
    cfg.data_set.source_name = source_names{j};
    cfg.data_set.snr = '';
    cfg.data_set.iteration = '1';
    cfg.snrs = snrs;
    cfg.save_tag = 'matched';
    
    %% Location: 295
    % Set up metric
    cfg.metrics.name = 'sinr';
    cfg.metrics.location_idx = 295;
    cfg.metrics.flip = false;
    
    % Compute SINR
    cfg = compute_sinr_vs_snr(cfg);
    % Plot SINR
    plot_sinr_vs_snr(cfg);
    
end

% Loop through source names
for j=1:length(source_names)
    
    %% ==== MISMATCHED LEADFIELD ====
    % Set up beamformer data sets to process
    beam_cfgs_mismatched = {...
        ...'rmv_epsilon_50_3sphere',...
        'rmv_epsilon_100_3sphere',...
        'rmv_epsilon_150_3sphere',...
        'rmv_epsilon_200_3sphere',...
        ...'rmv_epsilon_250_3sphere',...
        ...'rmv_epsilon_300_3sphere',...
        'rmv_aniso_3sphere',...
        'rmv_eig_pre_cov_0_epsilon_150_3sphere',...
        'rmv_eig_pre_cov_0_epsilon_200_3sphere',...
        ...'rmv_eig_post_0_epsilon_50_3sphere',...
        ...'rmv_eig_post_0_epsilon_100_3sphere',...
        'rmv_eig_post_0_epsilon_150_3sphere',...
        'rmv_eig_post_0_epsilon_200_3sphere',...
        ...'rmv_aniso_eig_0_3sphere',...
        'lcmv_3sphere',...
        'lcmv_eig_0_3sphere',...
        'lcmv_reg_eig_3sphere'};
    
    cfg.beam_cfgs = beam_cfgs_mismatched;
    
    % Set up simulation info
    cfg.data_set.sim_name = 'sim_data_bem_1_100t';
    cfg.data_set.source_name = source_names{j};
    cfg.data_set.snr = '';
    cfg.data_set.iteration = '1';
    cfg.snrs = snrs;
    cfg.save_tag = 'mismatched';
    
    %% Location: 295
    % Set up metric
    cfg.metrics.name = 'sinr';
    cfg.metrics.location_idx = 295;
    cfg.metrics.flip = false;
    
    % Compute SINR
    cfg = compute_sinr_vs_snr(cfg);
    % Plot SINR
    plot_sinr_vs_snr(cfg);
    
end