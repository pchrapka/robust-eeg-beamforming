%% run_sim_vars_test.m -- Script for running different analysis variations 

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
    'sim_data',             'sim_data_test',...
    'sim_src_parameters',   'src_param_mult_cortical_source_3');
scripts(k).vars = {cfg};
k = k+1;

%% Parameter sweep

force = true;

% Data files
cfg_data = [];
cfg_data.data_name = 'sim_data_test';
cfg_data.source_name = 'mult_cort_src_3';
cfg_data.iteration_range = 1;
cfg_data.snr_range = [-5 0 5 10];

% FIXME Still need somewhere to save the file
scripts(k).func = @sim_vars.run;
cfg = struct(...
    'sim_vars',             sim_vars.get_config(...
                                'sim_vars_test_mismatch',cfg_data,force),...
    'analysis_run_func',    @beamformer_analysis);
scripts(k).vars = {cfg};
k = k+1;

%% Run the scripts
aet_run_scripts( scripts );