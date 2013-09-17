function simulation()
% Simulation script

%% Initialize the Advanced EEG Toolbox
aet_init

%% Load the simulation parameters
sim_param_file

%% Control parallel execution explicity
sim_cfg.parallel = 'user';
aet_parallel_init(sim_cfg)

%% Simulation files
simulation_parameter_file = 'sim_param_file';
% source_parameter_file = 'src_param_single_cortical_source';
source_parameter_file = 'src_param_mult_cortical_source';

%% Simulations
% ADD SIMULATIONS HERE

simulation_ex1_snr(...
    simulation_parameter_file,...
    source_parameter_file);

%% End parallel execution
sim_cfg.parallel = '';
aet_parallel_close(sim_cfg)

end