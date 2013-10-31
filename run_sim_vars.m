%% run_simulation_3.m -- All example simulations
% Runs all the simulations using mult_cort_src_3

clear all;
close all;
clc;

%% Update AET, just in case
update_aet()

%% Initialize the Advanced EEG Toolbox
aet_init
k = 1;

%% Set up scripts to run


scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_1',...
    'sim_src_parameters',   'src_param_mult_cortical_source_3');
scripts(k).vars = {cfg};
k = k+1;

%% Parameter sweep

% FIXME Still need somewhere to save the file
scripts(k).func = @sim_vars.run;
cfg = struct(...
    'sim_vars',             sim_vars.get_config('sim_vars_1'),...
    'analysis_run_func',    @beamformer_analysis);
scripts(k).vars = {cfg};
k = k+1;

%% Run the scripts
aet_run_scripts( scripts );