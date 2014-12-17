function out = filename(cfg)
%FILENAME Generates a metrics file name
%   FILENAME(CFG) Generates a file name in the same directory as the
%   original EEG data set, with the same file name and a suffix describing
%   the metrics data. The suffix defaults to '_metrics'
%
%   cfg.file_tag
%       tag for file name, default = 'metrics'

%% Set up simulation info
cfg_data = cfg.data_set;
if isfield(cfg.data_set,'iterations')
    cfg_data.iteration = [num2str(min(cfg.data_set.iterations))...
        '-' num2str(max(cfg.data_set.iterations))];
end

%% Set up output file cfg
cfg_out = cfg_data;
if isfield(cfg, 'file_tag') && ~isempty(cfg.file_tag)
    cfg_out.tag = cfg.file_tag;
else
    cfg_out.tag = 'metrics';
end

%% Create the file name
out = db.save_setup(cfg_out);   

end