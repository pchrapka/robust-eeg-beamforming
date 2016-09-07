%% run_sim_vars.m -- Script for running different analysis variations 
% Goal: Recalculate the beamformer output from the last run to include all
% time points for flexibility in RMS analysis

clear all;
close all;
clc;

k = 1;

%% Set up scripts to run

%% Parameter sweep
force = false;

% Data files
data_files = get_sim_data_files(...
    'sim','sim_data_bem_100_100t',...
    'source','single_cort_src_1',...
    'iterations',1:100,...
    'snr',0 ...
    );

%% ==== MATCHED LEADFIELD ====

scripts(k).func = @sim_vars.run;
cfg_simvars_setup = [];
cfg_simvars_setup.id = 'sim_vars_single_src_paper_matched';
cfg_simvars_setup.data = cfg_data;
cfg_simvars_setup.force = force;
cfg_simvars = sim_vars.get_config(cfg_simvars_setup);
cfg = struct(...
    'sim_vars',             cfg_simvars,...
    'analysis_run_func',    @beamformer_calculate_output,...
    'debug',                false);
scripts(k).vars = {cfg};
k = k+1;

%% ==== MISMATCHED LEADFIELD ====

scripts(k).func = @sim_vars.run;
cfg_simvars_setup = [];
cfg_simvars_setup.id = 'sim_vars_single_src_paper_mismatched';
cfg_simvars_setup.data = cfg_data;
cfg_simvars_setup.force = force;
cfg_simvars_setup.tag = '3sphere';
cfg_simvars = sim_vars.get_config(cfg_simvars_setup);
cfg = struct(...
    'sim_vars',             cfg_simvars,...
    'analysis_run_func',    @beamformer_calculate_output);
scripts(k).vars = {cfg};
k = k+1;

%% Run the scripts
aet_run_scripts( scripts );