function out = add_tag(cfg)
%ADD_TAG returns the file name with a tag
%   ADD_TAG(CFG)
%   
%   cfg
%       file_name
%       tag         (optional)

if isfield(cfg,'tag') && ~isequal(cfg.tag,'')
    out = [cfg.file_name '_' cfg.tag];
else
    out = [cfg.file_name];
end

end