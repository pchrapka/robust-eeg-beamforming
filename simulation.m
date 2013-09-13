%% Simulation script

%% Clear everything
clc;
clear;
close all;

%% Initialize the Advanced EEG Toolbox
aet_init

%% Load the simulation parameters
sim_param_file

%% Control parallel execution explicity
sim_cfg.parallel = 'user';
aet_parallel_init(sim_cfg)

%% Simulations

simulation_ex1_snr(...
    'sim_param_file',...
    'src_param_single_cortical_source');

%% End parallel execution
sim_cfg.parallel = '';
aet_parallel_close(sim_cfg)