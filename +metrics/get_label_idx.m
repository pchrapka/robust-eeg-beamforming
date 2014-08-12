function [idx] = get_label_idx(labels, pattern)
    % Translate the string to a pattern, escaping all sketchy characters
    ptr =  regexptranslate('escape', pattern);
    idx = find(~cellfun(@isempty,...
        regexp(labels, ['^' ptr '$'])));
end