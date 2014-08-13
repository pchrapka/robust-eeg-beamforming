function [result] = metric_analysis_iter1_mult_paper(cfg_in)
%METRIC_ANALYSIS_ITER1_MULT_PAPER Sets up an analysis for multiple source
%data with 1 iteration
%
%   cfg_in.source_name
%       name of source config
%   cfg_in.snr
%       snr value
%
%   cfg_in.metrics
%       struct array of metric configs to pass to run_metrics_on_files
%       refer to the Metrics Section in the help of run_metrics_on_files

% Set common parameters
snr = cfg_in.snr;
source_name = cfg_in.source_name;

fprintf('Calculating metrics for %s %d snr\n', source_name, snr);

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

%% ==== MISMATCHED LEADFIELD ====
% Set up beamformer data sets to process
beam_cfgs_mismatched = {...
    'rmv_epsilon_50_3sphere',...
    'rmv_epsilon_100_3sphere',...
    'rmv_epsilon_150_3sphere',...
    'rmv_epsilon_200_3sphere',...
    'rmv_epsilon_250_3sphere',...
    'rmv_epsilon_300_3sphere',...
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

%% Set up the analysis
beam_cfgs = [...
    beam_cfgs_matched,...
    beam_cfgs_mismatched,...
    ];

cfg = [];
cfg.metrics = cfg_in.metrics;
cfg.beam_cfgs = beam_cfgs;

% Set up simulation info
cfg.data_set.sim_name = 'sim_data_bem_1_100t';
cfg.data_set.source_name = source_name;
cfg.data_set.snr = snr;
cfg.data_set.iteration = '1';

% Calculate the metrics
result = metrics.run_metrics_on_files(cfg);
% Save the results
metrics.save(cfg, result);

end