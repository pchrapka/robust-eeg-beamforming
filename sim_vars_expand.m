function variations = sim_vars_expand(sim_vars)
%SIM_VARS_EXPAND expands the variations in SIM_VARS

% Expand the variations from sim_vars
index=arrayfun(@(variations) (1:length(variations.values)), ...
    sim_vars, 'UniformOutput', false);
[index{:}]=ndgrid(index{:});

structarg=[{sim_vars.name}; ...
    arrayfun(@(variations,idx) (variations.values(idx{1})), ...
    sim_vars, index, 'UniformOutput', false)];
variations=struct(structarg{:});
clear index structarg
% Optinal reshapping structure in row
variations=reshape(variations,1,[]);

end