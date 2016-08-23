function metric_analysis_common_summary(cfg_in, results)
% Summarizes the common metric calculations
%
% cfg_in.source_name
%       name of source config

% Convert the data to csv format
csv_data = metrics.to_csv(results);

% Select the config
cfg = [];
cfg.sim_name = 'sim_data_bem_1_100t';
cfg.source_name = cfg_in.source_name;
cfg.snr = '0';
cfg.iteration = '1';

% Get the template data file name
data_file = db.save_setup(cfg);

% Save the csv data
cfg_save = [];
cfg_save.file_name = data_file;
cfg_save.save_name = 'metrics-common';
cfg_save.tag = 'summary';
cfg_save.col_labels = csv_data.col_labels;
cfg_save.col_format = csv_data.col_format;
cfg_save.data = csv_data.data;
metrics.save_csv(cfg_save);

end