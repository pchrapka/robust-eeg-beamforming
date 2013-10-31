function save_dir = get_file_dir(cfg)
%GET_FILE_DIR returns the file directory
%   GET_FILE_DIR(CFG)
%   
%   cfg
%       sim_name
%       source_name

% Get the directory that contains this function
if verLessThan('matlab', '7.14')
    [cur_dir,~,~,~] = fileparts(mfilename('fullpath'));
else
    [cur_dir,~,~] = fileparts(mfilename('fullpath'));
end

% Set up the output directory
out_dir = fullfile(cur_dir,'..','output');
save_dir = fullfile(out_dir,...
    cfg.sim_name, cfg.source_name);

end