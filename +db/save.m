function save(cfg, varargin)
%SAVE saves data in the output folder
%   SAVE(CFG, VARARGIN)
%   
%   cfg
%   Method 1 Save in a hierarchical directory specified by the following
%   fields
%       sim_name
%       source_name
%       snr
%       iteration
%       tag         (optional)
%
%   Method 2 Save in the same directory as another file
%       file_name
%       tag         (optional)

if ~isfield(cfg, 'file_name')
    % Method 1
    
    % Get the save directory
    save_dir = get_file_dir(cfg);
    
    % Check the output directory
    if ~exist(save_dir, 'dir');
        mkdir(save_dir);
    end
    
    % Set up the file name
    save_file = fullfile(save_dir, db.get_file_name(cfg));
    
else
    % Method 2
    % Get the directory that contains the file function
    if verLessThan('matlab', '7.14')
        [save_dir,~,~,~] = fileparts(cfg.file_name);
    else
        [save_dir,~,~] = fileparts(cfg.file_name);
    end
    
    % Add a tag
    tmpcfg = [];
    tmpcfg.file_name = cfg.file_name;
    tmpcfg.tag = cfg.tag;
    file_name = db.add_tag(tmpcfg);
    
    % Set up the file name
    save_file = fullfile(save_dir, file_name);
end

save(save_file, varargin{:})
end