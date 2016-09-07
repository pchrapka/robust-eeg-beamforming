%% run_sim_vars.m -- Script for running different analysis variations 

clear all;
close all;
clc;

k = 1;

%% set up head models
hmfactory = HeadModel();
hm_3sphere = hmfactory.creatHeadModel('brainstorm','head_Default1_3sphere_500V.mat');
hm_bem = hmfactory.creatHeadModel('brainstorm','head_Default1_bem_500V.mat');

%% Set up scripts to run

scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_2_100t',...
    'sim_src_parameters',   'src_param_mult_cortical_source_6');
scripts(k).vars = {cfg};
k = k+1;

%% Parameter sweep

% Redo analyses?
force = false;
% force = true; % ===== forcing another analysis ======

% Data files
cfg_data = [];
cfg_data.data_name = 'sim_data_2_100t';
cfg_data.source_name = 'mult_cort_src_6';
cfg_data.iteration_range = 1;
cfg_data.snr_range = -20:20:0;%-40:20:20; %-40:5:25

%% ==== MATCHED LEADFIELD ====

scripts(k).func = @sim_vars.run;
cfg_simvars_setup = [];
cfg_simvars_setup.id = 'sim_vars_lcmv';
cfg_simvars_setup.data = cfg_data;
cfg_simvars_setup.force = force;
cfg_simvars_setup.head = hm_3sphere;
cfg_simvars = sim_vars.get_config(cfg_simvars_setup);
cfg = struct(...
    'sim_vars',             cfg_simvars,...
    'analysis_run_func',    @beamformer_analysis);
scripts(k).vars = {cfg};
k = k+1;

scripts(k).func = @sim_vars.run;
cfg_simvars_setup = [];
cfg_simvars_setup.id = 'sim_vars_rmv_coarse';
cfg_simvars_setup.data = cfg_data;
cfg_simvars_setup.force = force;
cfg_simvars_setup.head = hm_3sphere;
cfg_simvars = sim_vars.get_config(cfg_simvars_setup);
cfg = struct(...
    'sim_vars',             cfg_simvars,...
    'analysis_run_func',    @beamformer_analysis);
scripts(k).vars = {cfg};
k = k+1;

scripts(k).func = @sim_vars.run;
cfg_simvars_setup = [];
cfg_simvars_setup.id = 'sim_vars_rmv_eig_coarse';
cfg_simvars_setup.data = cfg_data;
cfg_simvars_setup.force = force;
cfg_simvars_setup.head = hm_3sphere;
cfg_simvars = sim_vars.get_config(cfg_simvars_setup);
cfg = struct(...
    'sim_vars',             cfg_simvars,...
    'analysis_run_func',    @beamformer_analysis,...
    'debug',                false);
scripts(k).vars = {cfg};
k = k+1;

%% ==== MISMATCHED LEADFIELD ====

scripts(k).func = @sim_vars.run;
cfg_simvars_setup = [];
cfg_simvars_setup.id = 'sim_vars_lcmv_mismatch';
cfg_simvars_setup.data = cfg_data;
cfg_simvars_setup.force = force;
cfg_simvars_setup.head = hm_3sphere;
cfg_simvars = sim_vars.get_config(cfg_simvars_setup);
cfg = struct(...
    'sim_vars',             cfg_simvars,...
    'analysis_run_func',    @beamformer_analysis);
scripts(k).vars = {cfg};
k = k+1;

scripts(k).func = @sim_vars.run;
cfg_simvars_setup = [];
cfg_simvars_setup.id = 'sim_vars_rmv_coarse_mismatch';
cfg_simvars_setup.data = cfg_data;
cfg_simvars_setup.force = force;
cfg_simvars_setup.head = hm_3sphere;
cfg_simvars = sim_vars.get_config(cfg_simvars_setup);
cfg = struct(...
    'sim_vars',             cfg_simvars,...
    'analysis_run_func',    @beamformer_analysis);
scripts(k).vars = {cfg};
k = k+1;

scripts(k).func = @sim_vars.run;
cfg_simvars_setup = [];
cfg_simvars_setup.id = 'sim_vars_rmv_eig_coarse_mismatch';
cfg_simvars_setup.data = cfg_data;
cfg_simvars_setup.force = force;
cfg_simvars_setup.head = hm_3sphere;
cfg_simvars = sim_vars.get_config(cfg_simvars_setup);
cfg = struct(...
    'sim_vars',             cfg_simvars,...
    'analysis_run_func',    @beamformer_analysis);
scripts(k).vars = {cfg};
k = k+1;

%% Run the scripts
aet_run_scripts( scripts );