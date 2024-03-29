%% run_sim_vars_mult

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
    'sim_data',             'sim_data_2_100t',...
    'sim_src_parameters',   'src_param_mult_cortical_source_6');
scripts(k).vars = {cfg};
k = k+1;

%% Parameter sweep

% Redo analyses?
force = false;
% force = true; % ===== forcing another analysis ======

% Data files
data_files = get_sim_data_files(...
    'sim','sim_data_2_100t',...
    'source','mult_cort_src_6',...
    'iterations',1,...
    'snr',-20:20:0 ...
    ...'snr',-40:20:20 ...
    ...'snr',-40:5:25 ...
    );

%% ==== MATCHED LEADFIELD ====

scripts(k).func = @sim_vars.run;
cfg_simvars_setup = get_beamformer_config_set('sim_vars_lcmv');
cfg_simvars_setup.data_file = data_files;
cfg_simvars_setup.force = force;
cfg_simvars_setup.head = hm_3sphere;
cfg_simvars = get_beamformer_analysis_config(cfg_simvars_setup);
cfg = struct(...
    'sim_vars',             cfg_simvars,...
    'analysis_run_func',    @beamformer_analysis);
scripts(k).vars = {cfg};
k = k+1;

scripts(k).func = @sim_vars.run;
cfg_simvars_setup = get_beamformer_config_set('sim_vars_rmv_coarse');
cfg_simvars_setup.data_file = data_files;
cfg_simvars_setup.force = force;
cfg_simvars_setup.head = hm_3sphere;
cfg_simvars = get_beamformer_analysis_config(cfg_simvars_setup);
cfg = struct(...
    'sim_vars',             cfg_simvars,...
    'analysis_run_func',    @beamformer_analysis);
scripts(k).vars = {cfg};
k = k+1;

scripts(k).func = @sim_vars.run;
cfg_simvars_setup = get_beamformer_config_set('sim_vars_rmv_eig_coarse');
cfg_simvars_setup.data_file = data_files;
cfg_simvars_setup.force = force;
cfg_simvars_setup.head = hm_3sphere;
cfg_simvars = get_beamformer_analysis_config(cfg_simvars_setup);
cfg = struct(...
    'sim_vars',             cfg_simvars,...
    'analysis_run_func',    @beamformer_analysis,...
    'debug',                false);
scripts(k).vars = {cfg};
k = k+1;

%% ==== MISMATCHED LEADFIELD ====

scripts(k).func = @sim_vars.run;
cfg_simvars_setup = get_beamformer_config_set('sim_vars_lcmv_mismatch');
cfg_simvars_setup.data_file = data_files;
cfg_simvars_setup.force = force;
cfg_simvars_setup.head = hm_3sphere;
cfg_simvars = get_beamformer_analysis_config(cfg_simvars_setup);
cfg = struct(...
    'sim_vars',             cfg_simvars,...
    'analysis_run_func',    @beamformer_analysis);
scripts(k).vars = {cfg};
k = k+1;

scripts(k).func = @sim_vars.run;
cfg_simvars_setup = get_beamformer_config_set('sim_vars_rmv_coarse_mismatch');
cfg_simvars_setup.data_file = data_files;
cfg_simvars_setup.force = force;
cfg_simvars_setup.head = hm_3sphere;
cfg_simvars = get_beamformer_analysis_config(cfg_simvars_setup);
cfg = struct(...
    'sim_vars',             cfg_simvars,...
    'analysis_run_func',    @beamformer_analysis);
scripts(k).vars = {cfg};
k = k+1;

scripts(k).func = @sim_vars.run;
cfg_simvars_setup = get_beamformer_config_set('sim_vars_rmv_eig_coarse_mismatch');
cfg_simvars_setup.data_file = data_files;
cfg_simvars_setup.force = force;
cfg_simvars_setup.head = hm_3sphere;
cfg_simvars = get_beamformer_analysis_config(cfg_simvars_setup);
cfg = struct(...
    'sim_vars',             cfg_simvars,...
    'analysis_run_func',    @beamformer_analysis);
scripts(k).vars = {cfg};
k = k+1;

%% Run the scripts
aet_run_scripts( scripts );
