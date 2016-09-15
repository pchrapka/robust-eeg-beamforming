%% metric_analysis_sinr_all_mult

%% Set up different metrics to calculate
% Mult source results with 1 iteration

source_names = {...
    'mult_cort_src_10',...
    'mult_cort_src_17',...
    'mult_cort_src_17_lag8',...
    'mult_cort_src_17_lag40',...
    'mult_cort_src_sine_2',...
    'mult_cort_src_sine_2_uncor',...
    'mult_cort_src_complex_1_dip_pos_freq',...
    'distr_cort_src_2_point',...
    };
    

snrs = -20:10:0;

cfg = [];
% cfg.force = false;
cfg.force = true;
cfg.save_fig = true;

% Loop through source names
for j=1:length(source_names)
    
    %% ==== MATCHED LEADFIELD ====
    % Set up beamformer data sets to process
    beam_cfgs_matched = {...
        'rmv_epsilon_20',...
        ...'rmv_epsilon_50',...
        ...'rmv_eig_post_0_epsilon_20',...
        ...'rmv_eig_post_0_epsilon_50',...
        'lcmv',...
        'lcmv_eig_0',...
        'lcmv_eig_1',...
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
    cfg.metrics.location_idx = 295;
    
    % Set up metric
    cfg.metric_x = 'input snr';
    cfg.metric_y = 'output sinr';
    % Compute SINR
    cfg = compute_metric_output_vs_input(cfg);
    % Plot SINR
    plot_metric_output_vs_input(cfg);
    
    %% Location: 400
    cfg.metrics.location_idx = 400;
    
    % Set up metric
    cfg.metric_x = 'input snr';
    cfg.metric_y = 'output isnr';
    % Compute SINR
    cfg = compute_metric_output_vs_input(cfg);
    % Plot SINR
    plot_metric_output_vs_input(cfg);
    
    
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
        ...'rmv_eig_post_0_epsilon_50_3sphere',...
        ...'rmv_eig_post_0_epsilon_100_3sphere',...
        ....'rmv_eig_post_0_epsilon_150_3sphere',...
        ...'rmv_eig_post_0_epsilon_200_3sphere',...
        ...'rmv_aniso_eig_0_3sphere',...
        'lcmv_3sphere',...
        'lcmv_eig_0_3sphere',...
        'lcmv_eig_1_3sphere',...
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
    cfg.metrics.location_idx = 295;
    
    % Set up metric
    cfg.metric_x = 'input snr';
    cfg.metric_y = 'output sinr';
    % Compute SINR
    cfg = compute_metric_output_vs_input(cfg);
    % Plot SINR
    plot_metric_output_vs_input(cfg);
    
    %% Location: 400
    cfg.metrics.location_idx = 400;
    
    % Set up metric
    cfg.metric_x = 'input snr';
    cfg.metric_y = 'output isnr';
    % Compute SINR
    cfg = compute_metric_output_vs_input(cfg);
    % Plot SINR
    plot_metric_output_vs_input(cfg);
    
end
