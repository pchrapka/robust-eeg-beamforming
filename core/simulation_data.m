function simulation_data(cfg)
% Script for creating the data
% cfg
%   sim_cfg
%   sim_data
%   sim_src_parameters
%   parallel

if ~isfield(cfg,'sim_cfg')
    % Load the simulation parameters
    eval(cfg.sim_data);
    eval(cfg.sim_src_parameters);
else
    sim_cfg = cfg.sim_cfg;
end
% Set defaults
if ~isfield(cfg,'parallel'),    cfg.parallel = true;    end
if ~isfield(sim_cfg,'force'),   sim_cfg.force = false;  end
if ~isfield(sim_cfg,'debug'),   sim_cfg.debug = false;  end

%% Generate/load data

if sim_cfg.debug || ~cfg.parallel
    for j=1:length(sim_cfg.snr_range)
        for i=1:sim_cfg.n_runs
            simulation_data_inner(sim_cfg, j, i)
        end
    end
else
    % Control parallel execution explicity
    sim_cfg.parallel = 'user';
    aet_parallel_init(sim_cfg)
    
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
    
    % End parallel execution
    sim_cfg.parallel = '';
    aet_parallel_close(sim_cfg)
end

end