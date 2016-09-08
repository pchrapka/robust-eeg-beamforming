function simulation_data(cfg)
% Script for creating the data
% cfg
%   sim_cfg
%   sim_data
%   sim_src_parameters
%   parallel

% Save the cfg before we load the simulation parameters
cfg_copy = cfg;

if ~isfield(cfg,'sim_cfg')
    % Load the simulation parameters
    eval(cfg.sim_data);
    eval(cfg.sim_src_parameters);
else
    sim_cfg = cfg.sim_cfg;
end
% Set defaults
cfg = cfg_copy;
if ~isfield(cfg,'parallel'),    cfg.parallel = true;    end
if ~isfield(sim_cfg,'force'),   sim_cfg.force = false;  end
if ~isfield(sim_cfg,'debug'),   sim_cfg.debug = false;  end

%% Generate

if sim_cfg.debug || ~cfg.parallel
    for j=1:length(sim_cfg.snr_range)
        for i=1:sim_cfg.n_runs
            simulation_data_inner(sim_cfg, j, i)
        end
    end
else
    % set up parallel execution
    lumberjack.parfor_setup();
    
    % Parallelize based on which is longer
    if length(sim_cfg.snr_range) > sim_cfg.n_runs
        parfor j=1:length(sim_cfg.snr_range)
            % for j=1:length(sim_cfg.snr_range)
            for i=1:sim_cfg.n_runs
                simulation_data_inner(sim_cfg, j, i)
            end
        end
    else
        parfor i=1:sim_cfg.n_runs
            for j=1:length(sim_cfg.snr_range)
                simulation_data_inner(sim_cfg, j, i)
            end
        end
    end
    
end

end