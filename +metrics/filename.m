function outputfile = filename(cfg)
%FILENAME Generates a metrics file name
%   FILENAME(CFG) Generates a file name in the same directory as the
%   original EEG data set, with the same file name and a suffix describing
%   the metrics data. The file name can also be separated based on the file
%   type i.e. images or computed metrics
%
%   Data Set
%   --------
%   cfg.data_set
%       SimDataSetEEG object
%
%   File Options
%   ------------
%   cfg.file_tag (string, default = 'metrics')
%       tag for file name
%   cfg.file_type (string, optional)
%       specifies the file type 'img', 'metrics', which also creates a new
%       subdirectory where the data set exists
%       default = 'none'

% Set defaults
if ~isfield(cfg, 'file_type'),  cfg.file_type = 'none';     end
if ~isfield(cfg, 'file_tag'),   cfg.file_tag = 'metrics';   end

%% Set up simulation info
% cfg_data = cfg.data_set;
% if isfield(cfg.data_set,'iterations')
%     cfg_data.iteration = [num2str(min(cfg.data_set.iterations))...
%         '-' num2str(max(cfg.data_set.iterations))];
% end


%% Create the file name
outputfile = db.save_setup('data_set',cfg.data_set,'tag',cfg.file_tag);     

%% Create a subfolder
if ~isequal(cfg.file_type, 'none')
    % Get the data file dir
    [out_dir,name,ext] = fileparts(outputfile);
    switch cfg.file_type
        case 'img'
            % Set up an img dir
            out_dir = fullfile(out_dir, 'img');
        case 'metrics'
            % Set up a metrics dir
            out_dir = fullfile(out_dir, 'metrics');
    end
    if ~exist(out_dir, 'dir')
        mkdir(out_dir);
    end
    
    % Put it together again
    outputfile = fullfile(out_dir, [name ext]);
end

end