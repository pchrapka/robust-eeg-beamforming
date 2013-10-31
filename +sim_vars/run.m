function run(cfg)
%
%
%   cfg
%   cfg.sim_vars    array of structs describing simulation variations
%       name    string describing parameter
%       value   cell array of values
%
%   (unnecessary) cfg.analysis_setup_func     (function handle)
%       function for converting the
%   cfg.analysis_run_func   (function handle)
%       function to run the analysis, its argument will be a permutation of
%       the simulation variables
%       ex.
%           out = beamformer_analysis(params(i))

% Check if we can run parallel
run_parallel = sim_vars.check_parallel(cfg.sim_vars);

% Expand the variations from sim_vars
p = sim_vars.expand_vars(cfg.sim_vars);

% TODO No beamspace configuration yet

if run_parallel

    % Parallel
    analysis_run_func = cfg.analysis_run_func;
    parfor i=1:length(p)
        
        % FIXME
        % Maybe check if the output file already exists to avoid redoing
        % simulations if not necessary
        % - add a force flag
        
        % Run the simulation
        out = feval(analysis_run_func, p(i));
    end
else
    % Regular
    analysis_run_func = cfg.analysis_run_func;
    
    for i=length(p):-1:1
        
        % FIXME
        % Maybe check if the output file already exists to avoid redoing
        % simulations if not necessary
        % - add a force flag
        
        % Run the simulation
        out = feval(analysis_run_func, p(i));
    end
end

end