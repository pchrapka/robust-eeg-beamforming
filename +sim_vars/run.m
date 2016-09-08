function run(cfg)
%
%
%   cfg
%   cfg.debug       
%       (optional, default = false) runs the function in debug mode, with
%       no parallel execution
%   cfg.parallel       
%       (optional, default = true) runs the function in parallel
%   cfg.sim_vars    array of structs describing simulation variations
%       name    string describing parameter
%       value   cell array of values
%
%   cfg.analysis_run_func   (function handle)
%       function to run the analysis, its argument will be a permutation of
%       the simulation variables
%       ex.
%           out = beamformer_analysis(params(i))

% Set debug to be false by default
if ~isfield(cfg,'debug'),       cfg.debug = false;      end
if ~isfield(cfg,'parallel'),    cfg.parallel = true;    end

% Expand the variations from sim_vars
p = sim_vars.expand_vars(cfg.sim_vars);

if cfg.parallel && ~cfg.debug

    % set up parallel execution
    lumberjack.parfor_setup();
    
    % Parallel
    analysis_run_func = cfg.analysis_run_func;
    parfor i=1:length(p)
        
        % Run the simulation
        feval(analysis_run_func, p(i));
    end
    
else
    % Regular
    analysis_run_func = cfg.analysis_run_func;
    
    for i=length(p):-1:1
        
        % Run the simulation
        feval(analysis_run_func, p(i));
    end
end

end