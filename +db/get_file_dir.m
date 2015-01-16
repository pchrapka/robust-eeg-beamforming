function save_dir = get_file_dir(cfg)
%GET_FILE_DIR returns the file directory
%   GET_FILE_DIR(CFG)
%   
%   cfg
%       sim_name
%       source_name
%       relative (optional, default = true) flag for relative path

if ~isfield(cfg, 'relative'), cfg.relative = true; end

if ~cfg.relative
    % Get the directory that contains this function
    [cur_dir,~,~,~] = util.fileparts(mfilename('fullpath'));
    
    % Set up the output directory
    out_dir = fullfile(cur_dir,'..','output');
else
    % Set up the output directory
    out_dir = fullfile('output');
end

save_dir = fullfile(out_dir,...
    cfg.sim_name, cfg.source_name);

end