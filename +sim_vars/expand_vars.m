function variations = expand_vars(params)
%EXPAND_VARS expands the variations in PARAMS

% Expand the variations from params
index=arrayfun(@(variations) (1:length(variations.values)), ...
    params, 'UniformOutput', false);
[index{:}]=ndgrid(index{:});

structarg=[{params.name}; ...
    arrayfun(@(variations,idx) (variations.values(idx{1})), ...
    params, index, 'UniformOutput', false)];
variations=struct(structarg{:});
clear index structarg
% Optinal reshapping structure in row
variations=reshape(variations,1,[]);

end