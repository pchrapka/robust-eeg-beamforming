%% run_simulation.m -- All example simulations
% Runs all the simulations

clear all;
close all;
clc;

%% Update AET, just in case
update_aet()

%% Initialize the Advanced EEG Toolbox
aet_init

scripts = {...
    % Create data
    'simulation_data',...
    % Simulations
    'simulation'...
};

%% Run the scripts
aet_run_scripts( scripts );
