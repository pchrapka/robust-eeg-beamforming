%% run_sim_vars_bemhd_paper_distr2hd
% Same as run_sim_vars_distr_bem_paper except with a higher resolution head
% model

clear all;
close all;
clc;

k = 1;

%% Set up scripts to run

% Simulate ERP data
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bemhd_1_100t',...
    'sim_src_parameters',   'src_param_distr_cortical_source_2hd',...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

%% Parameter sweep
force = false;

% Data files
cfg_data = [];
cfg_data.data_name = 'sim_data_bemhd_1_100t';
cfg_data.source_name = 'distr_cort_src_2hd';
cfg_data.iteration_range = 1;
cfg_data.snr_range = 0;%-20:10:0;

%% ==== MATCHED LEADFIELD ====

scripts(k).func = @sim_vars.run;
cfg_simvars_setup = [];
cfg_simvars_setup.id = 'sim_vars_distr_src_paper_matched';
cfg_simvars_setup.loc = 1:15028;
cfg_simvars_setup.data = cfg_data;
cfg_simvars_setup.force = force;
cfg_simvars_setup.head.type = 'brainstorm';
cfg_simvars_setup.head.file = 'head_Default1_bem_15028V.mat';
cfg_simvars = sim_vars.get_config(cfg_simvars_setup);
cfg = struct(...
    'sim_vars',             cfg_simvars,...
    'analysis_run_func',    @beamformer_analysis,...
    ...Allow parallel execution of the scans, by setting parallel to false
    'parallel',             false,...
    'debug',                false);
scripts(k).vars = {cfg};
k = k+1;

%% ==== MISMATCHED LEADFIELD ====

scripts(k).func = @sim_vars.run;
cfg_simvars_setup = [];
cfg_simvars_setup.id = 'sim_vars_distr_src_paper_mismatched';
cfg_simvars_setup.loc = 1:15028;
cfg_simvars_setup.data = cfg_data;
cfg_simvars_setup.force = force;
cfg_simvars_setup.tag = '3sphere';
cfg_simvars_setup.head.current.type = 'brainstorm';
cfg_simvars_setup.head.current.file = 'head_Default1_3sphere_15028V.mat';
cfg_simvars_setup.head.actual.type = 'brainstorm';
cfg_simvars_setup.head.actual.file = 'head_Default1_bem_15028V.mat';
cfg_simvars = sim_vars.get_config(cfg_simvars_setup);
cfg = struct(...
    'sim_vars',             cfg_simvars,...
    'analysis_run_func',    @beamformer_analysis,...
    ...Allow parallel execution of the scans, by setting parallel to false
    'parallel',             false,...
    'debug',                false);
scripts(k).vars = {cfg};
k = k+1;

%% Run the scripts
aet_run_scripts( scripts );