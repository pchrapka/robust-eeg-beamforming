function out = add_tag(file_name, tag)
%ADD_TAG returns the file name with a tag
%   ADD_TAG(file_name, tag)
%   
%   file_name
%   tag

p = inputParser();
addRequired(p,'file_name',@(x) ~isempty(x) && ischar(x));
addRequired(p,'tag',@(x) ~isempty(x) && ischar(x));
parse(p,file_name,tag);

out = [p.Results.file_name '_' p.Results.tag];

end