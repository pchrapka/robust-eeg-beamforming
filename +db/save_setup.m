function save_file = save_setup(cfg)
%SAVE_SETUP saves data in the output folder
%   SAVE_SETUP(CFG)
%   
%   cfg
%   Method 1 Save in a hierarchical directory specified by the following
%   fields
%       sim_name
%       source_name
%       snr
%       iteration
%       tag         (optional)
%       ext         (optional) file extension, default .mat
%
%   Method 2 Save in the same directory as another file
%       file_name
%       save_name   
%           (optional) serves as the base of the file name
%       tag         
%           (optional) it's recommended to add a tag to not overwrite
%       ext         
%           (optional) file extension, default .mat

if ~isfield(cfg, 'file_name')
    % Method 1
    if ~isfield(cfg,'ext')
        cfg.ext = '.mat';
    end
    
    % Get the save directory
    save_dir = db.get_file_dir(cfg);
    
    % Check the output directory
    if ~exist(save_dir, 'dir');
        mkdir(save_dir);
    end
    
    % Set up the file name
    save_file = fullfile(save_dir, [db.get_file_name(cfg) cfg.ext]);
    
else
    % Method 2
    if ~isfield(cfg,'ext')
        cfg.ext = '.mat';
    end
    
    % Get the directory that contains the file function
    [save_dir,save_name,~,~] = util.fileparts(cfg.file_name);
    
    % Add a tag
    tmpcfg = [];
    if isfield(cfg,'save_name')
        % Add optional tag
        if isfield(cfg, 'tag') && ~isempty(cfg.tag)
            tmpcfg.file_name = cfg.save_name;
            tmpcfg.tag = cfg.tag;
            file_name = db.add_tag(tmpcfg);
        else
            % Not adding a tag, so check if we're overwriting
            if isequal(cfg.save_name, save_name) && isequal(cfg.tag,'')
                warning('db:save_setup',...
                    ['the save name is similar to the original file, '...
                    'consider adding a tag']);
            end
            file_name = cfg.save_name;
        end
    else
        tmpcfg.file_name = save_name;
        tmpcfg.tag = cfg.tag;
        file_name = db.add_tag(tmpcfg);
    end
    
    % Set up the file name
    save_file = fullfile(save_dir, [file_name cfg.ext]);
    
    % Check if there's a new directory
    [save_dir,~,~,~] = util.fileparts(save_file);
    % Check the output directory
    if ~exist(save_dir, 'dir');
        mkdir(save_dir);
    end
end

end