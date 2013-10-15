function simulation_variations_all(cfg)
%SIMULATION_VARIATIONS_ALL runs simulation sweeps for all beamformer types
%   SIMULATION_VARIATIONS_ALL(CFG)
%
%   Requires 
%       sim_vars parameter file
%       sim_cfg from a sim_data and source parameter file
%


% Load the simulation parameters
eval(cfg.sim_data);
eval(cfg.sim_vars);
eval(cfg.sim_src_parameters);
eval(cfg.sim_beam);

%% Control parallel execution explicity
sim_cfg.parallel = 'user';
aet_parallel_init(sim_cfg)

%% Run simulations
for i=1:length(sim_cfg.beamformer_types);
    sim_cfg.out_file_name = [...
        'out_'...
        sim_vars_name '_'...
        sim_cfg.beamformer_types{i} '.mat'];
    % Select the beamformer
    sim_cfg.beamformer_type = sim_cfg.beamformer_types{i};
    % Run the simulation
    simulation_variations(sim_vars, sim_cfg)
end

%% End parallel execution
sim_cfg.parallel = '';
aet_parallel_close(sim_cfg)


end
