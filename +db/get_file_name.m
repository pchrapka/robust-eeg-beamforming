function out = get_file_name(cfg)
%GET_FILE_NAME returns a file name from CFG
%   GET_FILE_NAME(CFG)
%   
%   cfg
%       snr
%       iteration
%       tag         (optional)

if isfield(cfg,'tag') && ~isequal(cfg.tag,'')
    out = [num2str(cfg.snr) '_' num2str(cfg.iteration)...
        '_' cfg.tag '.mat'];
else
    out = [num2str(cfg.snr) '_' num2str(cfg.iteration) '.mat'];
end

end