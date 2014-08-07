%% run_sim_vars_source_configs
% Script to generate data for source configs

clear all;
close all;
clc;

%% Update AET, just in case
util.update_aet();

%% Initialize the Advanced EEG Toolbox
aet_init
k = 1;

%% Set up scripts to run

%% src_param_single_cortical_source_complex_1
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t',...
    'sim_src_parameters',   'src_param_single_cortical_source_complex_1',...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

%% src_param_single_cortical_source_complex_2
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t',...
    'sim_src_parameters',   'src_param_single_cortical_source_complex_2',...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

%% src_param_single_cortical_source_complex_2_freq
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t',...
    'sim_src_parameters',   'src_param_single_cortical_source_complex_2_freq',...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

%% src_param_single_cortical_source_complex_2_dip
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t',...
    'sim_src_parameters',   'src_param_single_cortical_source_complex_2_dip',...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

%% Run the scripts
aet_parallel_init([]);
aet_run_scripts( scripts );