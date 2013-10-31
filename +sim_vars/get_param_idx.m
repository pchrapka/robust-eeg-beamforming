function idx = get_param_idx(params, parameter_name)
%GET_PARAM_IDX(PARAMS, PARAMETER_NAME) returns the index of the
%PARAMETER_NAME in PARAMS
a = cellfun(@(x)isequal(x, parameter_name),{params.name});
idx = find(a == 1, 'first');
end