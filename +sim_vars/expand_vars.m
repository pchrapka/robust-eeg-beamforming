function variations = expand_vars(params)
%EXPAND_VARS expands the variations in PARAMS

debug = false;

% Expand the variations from params
index=arrayfun(@(variations) (1:length(variations.values)), ...
    params, 'UniformOutput', false);
% Extract single params
index_mult = [];
index_single = [];
for i=1:length(index)
    if length(index{i}) > 1
        index_mult(end+1) = i;
    else
        index_single(end+1) = i;
    end
end
params_single = params(index_single);
params = params(index_mult);
index = index(index_mult);

% Expand the multiple option variations
[index{:}]=ndgrid(index{:});

structarg=[{params.name}; ...
    arrayfun(@(variations,idx) (variations.values(idx{1})), ...
    params, index, 'UniformOutput', false)];
variations=struct(structarg{:});
clear index structarg
% Optinal reshapping structure in row
variations=reshape(variations,1,[]);

% Add the single params
for i=1:length(variations)
    for j=1:length(params_single)
        name = params_single(j).name;
        value = params_single(j).values{1};
        variations(i).(name) = value;
    end
    
    if debug
        disp(variations(i));
    end
end

end