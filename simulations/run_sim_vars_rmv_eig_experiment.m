%% run_sim_vars.m -- Script for running different analysis variations 

clear all;
close all;
clc;

%% Update AET, just in case
update_aet()

%% Initialize the Advanced EEG Toolbox
aet_init
k = 1;

%% Set up scripts to run


% scripts(k).func = @simulation_data;
% cfg = struct(...
%     'sim_data',             'sim_data_2_test_beamformer',...
%     'sim_src_parameters',   'src_param_single_cortical_source_1');
% scripts(k).vars = {cfg};
% k = k+1;

%% Parameter sweep
force = false;

% Data files
cfg_data = [];
cfg_data.data_name = 'sim_data_2_test_beamformer';
cfg_data.source_name = 'single_cort_src_1';
cfg_data.iteration_range = 1;
cfg_data.snr_range = 0:20:20;%-40:20:20; %-40:5:25

%% ==== MATCHED LEADFIELD ====

scripts(k).func = @sim_vars.run;
cfg = struct(...
    'sim_vars',             sim_vars.get_config(...
                                'sim_vars_rmv_eig_coarse', cfg_data, force),...
    'analysis_run_func',    @beamformer_analysis,...
    'debug',                false);
scripts(k).vars = {cfg};
k = k+1;

%% Run the scripts
aet_run_scripts( scripts );