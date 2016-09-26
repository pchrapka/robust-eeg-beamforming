function save(cfg, data)
%SAVE Saves the metrics data based on the config supplied to
%RUN_METRICS_ON_FILES
%   SAVE(CFG) Saves the output in the same directory as the
%   original EEG data set, with the same file name and the following
%   suffixes: '_metrics'
%
%   cfg.data_set
%       struct specifying data set we're using
%   cfg.file_tag
%       tag for saving files, default = 'metrics'

save_file = metrics.filename(cfg);
print_save(save_file);
save(save_file, 'data');

end