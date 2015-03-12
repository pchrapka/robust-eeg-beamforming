function out = filename(cfg)
%FILENAME Generates a metrics file name
%   FILENAME(CFG) Generates a file name in the same directory as the
%   original EEG data set, with the same file name and a suffix describing
%   the metrics data. The file name can also be separated based on the file
%   type i.e. images or computed metrics
%
%   Data Set
%   --------
%   cfg.data_set with the following fields
%   sim_name    simulation config name
%   source_name source config name
%   snr         snr
%   iteration   simulation iteration
%
%     Example:
%     cfg.data_set.sim_name = 'sim_data_bem_1_100t';
%     cfg.data_set.source_name = 'mult_cort_src_10';
%     cfg.data_set.snr = 0;
%     cfg.data_set.iteration = '1';
%
%   File Options
%   ------------
%   cfg.file_tag
%       tag for file name, default = 'metrics'
%   cfg.file_type (optional)
%       specifies the file type 'img', 'metrics', which also creates a new
%       subdirectory where the data set exists
%       default = 'none'

% Set defaults
if ~isfield(cfg, 'file_type'), cfg.file_type = 'none'; end

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

%% Create a subfolder
if ~isequal(cfg.file_type, 'none')
    % Get the data file dir
    [out_dir,name,ext] = fileparts(out);
    switch cfg.file_type
        case 'img'
            % Set up an img dir
            out_dir = fullfile(out_dir, 'img');
        case 'metrics'
            % Set up a metrics dir
            out_dir = fullfile(out_dir, 'metrics');
    end
    
    % Put it together again
    out = fullfile(out_dir, [name ext]);
end

end