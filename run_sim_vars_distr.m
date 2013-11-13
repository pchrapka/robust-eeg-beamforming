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

% 
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_2',...
    'sim_src_parameters',   'src_param_distr_cortical_source_2');
scripts(k).vars = {cfg};
k = k+1;

%% Parameter sweep

% Redo analyses?
force = false;

% Data files
cfg_data = [];
cfg_data.data_name = 'sim_data_2';
cfg_data.source_name = 'distr_cort_src_2';
cfg_data.iteration_range = 1;
cfg_data.snr_range = -40:20:20; %-40:5:25

% FIXME Still need somewhere to save the file
scripts(k).func = @sim_vars.run;
cfg = struct(...
    'sim_vars',             sim_vars.get_config(...
                                'sim_vars_lcmv',cfg_data, force),...
    'analysis_run_func',    @beamformer_analysis);
scripts(k).vars = {cfg};
k = k+1;

scripts(k).func = @sim_vars.run;
cfg = struct(...
    'sim_vars',             sim_vars.get_config(...
                                'sim_vars_rmv_coarse',cfg_data, force),...
    'analysis_run_func',    @beamformer_analysis);
scripts(k).vars = {cfg};
k = k+1;

force = true; % ===== forcing another analysis ======
scripts(k).func = @sim_vars.run;
cfg = struct(...
    'sim_vars',             sim_vars.get_config(...
                                'sim_vars_rmv_eig_coarse',cfg_data, force),...
    'analysis_run_func',    @beamformer_analysis);
scripts(k).vars = {cfg};
k = k+1;

%% Run the scripts
aet_run_scripts( scripts );