function [result] = metric_analysis_common_paper(cfg_in)
%METRIC_ANALYSIS_COMMON_PAPER Sets up an analysis for common metrics
%
%   cfg_in.metrics
%       struct array of metric configs to pass to run_metrics_on_files
%       refer to the Metrics Section in the help of run_metrics_on_files

% Set common parameters
snr = cfg_in.snr;
source_name = cfg_in.source_name;

fprintf('Calculating metrics for %s %d snr\n', source_name, snr);

%% Set up the analysis

cfg = [];
cfg.metrics = cfg_in.metrics;

% Set up simulation info
cfg.data_set.sim_name = 'sim_data_bem_1_100t';
cfg.data_set.source_name = source_name;
cfg.data_set.snr = snr;
cfg.data_set.iteration = '1';

% Set up a fake data file
data = [];
save_file = db.save_setup(cfg.data_set);
save(save_file, 'data');

% Calculate the metrics
result(1) = metrics.run_metrics_on_file(cfg);
% Save the results
metrics.save(cfg, result);

end