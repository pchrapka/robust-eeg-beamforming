function save(cfg, data)
%SAVE Saves the metrics data based on the config supplied to
%RUN_METRICS_ON_FILES
%   SAVE(CFG) Saves the output in the same directory as the
%   original EEG data set, with the same file name and the following
%   suffixes: '_metrics'

%% Set up simulation info
cfg_data = cfg.data_set;
if isfield(cfg.data_set,'iterations')
    cfg_data.iteration = [num2str(min(cfg.data_set.iterations))...
        '-' num2str(max(cfg.data_set.iterations))];
end

%% Save the data
% Set up output file cfg
cfg_out = cfg_data;
cfg_out.tag = 'metrics';
save_file = db.save_setup(cfg_out);
[~,name,~,~] = util.fileparts(save_file);
fprintf('Saving as: %s\n', name);
save(save_file, 'data');

end