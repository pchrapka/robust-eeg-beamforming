function save(cfg, varargin)
%SAVE saves data in the output folder
%   SAVE(CFG, VARARGIN)
%   
%   cfg
%       sim_name
%       source_name
%       snr
%       iteration
%       tag         (optional)


% Set up the output directory
out_dir = fullfile('..','output');
save_dir = fullfile(out_dir,...
    cfg.sim_name, cfg.source_name);

% Check the output directory
if ~exist(save_dir, 'dir');
    mkdir(save_dir);
end

% Set up the file name
save_file = fullfile(save_dir, db.get_file_name(cfg));

save(save_file, varargin{:})
end