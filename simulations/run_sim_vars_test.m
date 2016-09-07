%% run_sim_vars_test.m -- Script for running different analysis variations 

clear all;
close all;
clc;

k = 1;

%% set up head models
hmfactory = HeadModel();
hm_3sphere = hmfactory.createHeadModel('brainstorm','head_Default1_3sphere_500V.mat');
hm_bem = hmfactory.createHeadModel('brainstorm','head_Default1_bem_500V.mat');

%% Set up scripts to run


scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_test',...
    'sim_src_parameters',   'src_param_mult_cortical_source_3',...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

%% Parameter sweep

force = true;

% Data files
data_files = get_sim_data_files(...
    'sim','sim_data_test',...
    'source','mult_cort_src_3',...
    'iterations',1,...
    'snr',-10:10:10 ...
    );

scripts(k).func = @sim_vars.run;
cfg_simvars_setup = get_beamformer_config_set('sim_vars_test_mismatch');
cfg_simvars_setup.data_file = data_files;
cfg_simvars_setup.force = force;
cfg_simvars_setup.head = hm_3sphere;
cfg_simvars = get_beamformer_analysis_config(cfg_simvars_setup);
cfg = struct(...
    'sim_vars',             cfg_simvars,...
    'analysis_run_func',    @beamformer_analysis,...
    ...Allow parallel execution of the scans, by setting parallel to false
    'parallel',             false,...
    'debug',                true);
scripts(k).vars = {cfg};
k = k+1;

%% Run the scripts
aet_run_scripts( scripts );
