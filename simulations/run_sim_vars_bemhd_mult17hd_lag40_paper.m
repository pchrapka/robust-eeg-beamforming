%% run_sim_vars_bemhd_mult17hd_lag40_paper.m
% Same as run_sim_vars_mult_bem_paper except with a higher resolution head
% model

clear all;
close all;
clc;

k = 1;

%% set up head models
hmfactory = HeadModel();
hm_3sphere = hmfactory.createHeadModel('brainstorm','head_Default1_3sphere_15028V.mat');
hm_bem = hmfactory.createHeadModel('brainstorm','head_Default1_bem_15028V.mat');

%% Set up scripts to run

% Simulate ERP data
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bemhd_1_100t_1000s',...
    'snr_range',            0,...
    'sim_src_parameters',   'src_param_mult_cortical_source_17hd_lag40',...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

%% Parameter sweep
force = false;

% Data files
data_files = get_sim_data_files(...
    'sim','sim_data_bemhd_1_100t_1000s',...
    'source','mult_cort_src_17hd_lag40',...
    'iterations',1,...
    ...'snr',-20:10:0 ...
    ...'snr',-10:10:0 ...
    'snr',0 ...
    );

%% ==== MATCHED LEADFIELD ====

scripts(k).func = @sim_vars.run;
cfg_simvars_setup = get_beamformer_config_set('sim_vars_mult_src_paper_matched');
cfg_simvars_setup.loc = 1:15028;%5440;
cfg_simvars_setup.data_file = data_files;
cfg_simvars_setup.force = force;
cfg_simvars_setup.head = hm_bem;
cfg_simvars = get_beamformer_analysis_config(cfg_simvars_setup);
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
cfg_simvars_setup = get_beamformer_config_set('sim_vars_mult_src_paper_mismatched');
cfg_simvars_setup.loc = 1:15028;%5440;
cfg_simvars_setup.data_file = data_files;
cfg_simvars_setup.force = force;
cfg_simvars_setup.tag = '3sphere';
cfg_simvars_setup.head = [];
cfg_simvars_setup.head.current = hm_3sphere;
cfg_simvars_setup.head.actual = hm_bem;
cfg_simvars = get_beamformer_analysis_config(cfg_simvars_setup);
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
