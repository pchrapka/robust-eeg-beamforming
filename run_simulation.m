%% run_simulation.m -- All example simulations
% Runs all the simulations

clear all;
close all;
clc;
%% Initialize the Advanced EEG Toolbox
aet_init

scripts = {...
    % Create data
    'simulation_data'...
    ...%% Example 1
    ...'simulation_ex1_snr',...        % Output performance vs SNR
    ...'simulation_ex1_epsilon',...    % Output performance vs epsilon
    ...%% Example 2
    ...'simulation_ex2_snr',...        % Output performance vs SNR
    ...'simulation_ex2_epsilon',...     % Output performance vs epsilon
    ...%% Example 3
    ...'simulation_ex3_snr'...        % Output performance vs SNR
    ...%% Example 4
    ...'simulation_ex4_snr',...        % Output performance vs SNR
    ...'simulation_ex4_epsilon'...,...     % Output performance vs epsilon
};

%% Run the scripts
aet_run_scripts( scripts );
