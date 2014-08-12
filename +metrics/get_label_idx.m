function [idx] = get_label_idx(labels, pattern)
    idx = find(~cellfun(@isempty,regexp(labels, pattern)));
end