function out = get_full_file_name(cfg)
%GET_FULL_FILE_NAME returns the full file path
%   GET_FULL_FILE_NAME(CFG)
%
%   cfg
%       sim_name
%       source_name
%       snr
%       iteration
%       tag         (optional)

out = fullfile(db.get_file_dir(cfg), db.get_file_name(cfg));
end