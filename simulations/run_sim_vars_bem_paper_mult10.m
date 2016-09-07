%% run_sim_vars.m -- Script for running different analysis variations 

clear all;
close all;
clc;

k = 1;

%% set up head models
hmfactory = HeadModel();
hm_3sphere = hmfactory.createHeadModel('brainstorm','head_Default1_3sphere_500V.mat');
hm_bem = hmfactory.createHeadModel('brainstorm','head_Default1_bem_500V.mat');

%% Set up scripts to run

% Simulate ERP data
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t',...
    'sim_src_parameters',   'src_param_mult_cortical_source_10',...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

%% Parameter sweep
force = false;

% Data files
cfg_data = [];
cfg_data.data_name = 'sim_data_bem_1_100t';
cfg_data.source_name = 'mult_cort_src_10';
cfg_data.iteration_range = 1;
cfg_data.snr_range = -20:10:0;%-10:10:0;%0;

%% ==== MATCHED LEADFIELD ====

scripts(k).func = @sim_vars.run;
cfg_simvars_setup = [];
cfg_simvars_setup.id = 'sim_vars_mult_src_paper_matched';
cfg_simvars_setup.data = cfg_data;
cfg_simvars_setup.force = force;
cfg_simvars_setup.head = hm_bem;
cfg_simvars = sim_vars.get_config(cfg_simvars_setup);
cfg = struct(...
    'sim_vars',             cfg_simvars,...
    'analysis_run_func',    @beamformer_analysis,...
    ...Allow parallel execution of the scans
    'parallel',             false,...
    'debug',                false);
scripts(k).vars = {cfg};
k = k+1;

%% ==== MISMATCHED LEADFIELD ====

scripts(k).func = @sim_vars.run;
cfg_simvars_setup = [];
cfg_simvars_setup.id = 'sim_vars_mult_src_paper_mismatched';
cfg_simvars_setup.data = cfg_data;
cfg_simvars_setup.force = force;
cfg_simvars_setup.tag = '3sphere';
cfg_simvars_setup.head.current = hm_3sphere;
cfg_simvars_setup.head.actual = hm_bem;
cfg_simvars = sim_vars.get_config(cfg_simvars_setup);
cfg = struct(...
    'sim_vars',             cfg_simvars,...
    'analysis_run_func',    @beamformer_analysis,...
    ...Allow parallel execution of the scans
    'parallel',             false,...
    'debug',                false);
scripts(k).vars = {cfg};
k = k+1;

%% Run the scripts
aet_run_scripts( scripts );
