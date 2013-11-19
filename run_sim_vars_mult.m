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
    'sim_src_parameters',   'src_param_mult_cortical_source_6');
scripts(k).vars = {cfg};
k = k+1;

%% Parameter sweep

% Redo analyses?
force = false;
% force = true; % ===== forcing another analysis ======

% Data files
cfg_data = [];
cfg_data.data_name = 'sim_data_2';
cfg_data.source_name = 'mult_cort_src_6';
cfg_data.iteration_range = 1;
cfg_data.snr_range = -40:20:20; %-40:5:25

%% ==== MATCHED LEADFIELD ====
scripts(k).func = @sim_vars.run;
cfg = struct(...
    'sim_vars',             sim_vars.get_config(...
                                'sim_vars_lcmv', cfg_data, force),...
    'analysis_run_func',    @beamformer_analysis);
scripts(k).vars = {cfg};
k = k+1;

scripts(k).func = @sim_vars.run;
cfg = struct(...
    'sim_vars',             sim_vars.get_config(...
                                'sim_vars_rmv_coarse', cfg_data, force),...
    'analysis_run_func',    @beamformer_analysis);
scripts(k).vars = {cfg};
k = k+1;

scripts(k).func = @sim_vars.run;
cfg = struct(...
    'sim_vars',             sim_vars.get_config(...
                                'sim_vars_rmv_eig_coarse', cfg_data, force),...
    'analysis_run_func',    @beamformer_analysis,...
    'debug',                false);
scripts(k).vars = {cfg};
k = k+1;

%% ==== MISMATCHED LEADFIELD ====
scripts(k).func = @sim_vars.run;
cfg = struct(...
    'sim_vars',             sim_vars.get_config(...
                                'sim_vars_lcmv_mismatch', cfg_data, force),...
    'analysis_run_func',    @beamformer_analysis);
scripts(k).vars = {cfg};
k = k+1;

scripts(k).func = @sim_vars.run;
cfg = struct(...
    'sim_vars',             sim_vars.get_config(...
                                'sim_vars_rmv_coarse_mismatch', cfg_data, force),...
    'analysis_run_func',    @beamformer_analysis);
scripts(k).vars = {cfg};
k = k+1;

scripts(k).func = @sim_vars.run;
cfg = struct(...
    'sim_vars',             sim_vars.get_config(...
                                'sim_vars_rmv_eig_coarse_mismatch', cfg_data, force),...
    'analysis_run_func',    @beamformer_analysis,...
    'debug',                false);
scripts(k).vars = {cfg};
k = k+1;

%% Run the scripts
aet_run_scripts( scripts );