function run_parallel = sim_vars_check_parallel(sim_vars)
%SIM_VARS_CHECK_PARALLEL checks if we can run parallel
%   SIM_VARS_CHECK_PARALLEL(SIM_VARS) returns a boolean stating if it's
%   advisable to run the simulation variations in parallel. It basically
%   checks if there are any RMV beamformer configurations contained within
%   SIM_VARS

run_parallel = true;
beam_idx = sim_vars_get_param_idx(sim_vars,'beamformer_config');
if ~isempty(beam_idx)
    % Check if there is RMV beamformer configuration
    rmv_matches = cellfun(@(x)isequal(x, 'rmv'),...
        sim_vars(beam_idx).values);
    if sum(rmv_matches) > 0
        warning('reb:sim_vars_check_parallel',...
            ['Better off running RMV beamformer in a '...
            'separate simulation to use parrallel execution']);
        run_parallel = false;
    end
end

end