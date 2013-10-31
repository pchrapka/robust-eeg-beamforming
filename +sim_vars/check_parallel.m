function run_parallel = check_parallel(params)
%CHECK_PARALLEL checks if we can run parallel
%   CHECK_PARALLEL(PARAMS) returns a boolean stating if it's
%   advisable to run the simulation variations in parallel. It basically
%   checks if there are any RMV beamformer configurations contained within
%   SIM_VARS

run_parallel = true;
beam_idx = sim_vars.get_param_idx(params,'beamformer_config');
if ~isempty(beam_idx)
    % Check if there is RMV beamformer configuration
    rmv_matches = cellfun(@(x)isequal(x, 'rmv'),...
        params(beam_idx).values);
    if sum(rmv_matches) > 0
        warning('sim_vars:check_parallel',...
            ['Better off running RMV beamformer in a '...
            'separate simulation to use parrallel execution']);
        run_parallel = false;
    end
end

end