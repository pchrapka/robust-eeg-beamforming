function idx = sim_vars_get_param_idx(sim_vars, parameter_name)
%SIM_VARS_GET_PARAM_IDX(SIM_VARS, PARAMETER_NAME) returns the index of the
%PARAMETER_NAME in SIM_VARS
a = cellfun(@(x)isequal(x, parameter_name),{sim_vars.name});
idx = find(a == 1, 'first');
end