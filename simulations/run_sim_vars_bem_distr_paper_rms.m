%% run_sim_vars_bem_distr_paper_rms

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
    'sim_data',             'sim_data_bem_100_100t',...
    'sim_src_parameters',   'src_param_distr_cortical_source_2',...
    'snr_range',            0,...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

%% Parameter sweep
force = false;
% 0.452 comes from the time point selected for display in the paper
time_idx = 250*0.452;

% Data files
data_files = get_sim_data_files(...
    'sim','sim_data_bem_100_100t',...
    'source','distr_cort_src_2',...
    'iterations',1:100,...
    ...'snr',-20:10:0 ...
    ...'snr',-10:10:0 ...
    'snr',0 ...
    );

%% ==== MATCHED LEADFIELD ====

scripts(k).func = @sim_vars.run;
cfg_simvars_setup = get_beamformer_config_set('sim_vars_distr_src_paper_matched');
cfg_simvars_setup.data_file = data_files;
cfg_simvars_setup.force = force;
% cfg_simvars_setup.time_idx = time_idx;
cfg_simvars_setup.head = hm_bem;
cfg_simvars = get_beamformer_analysis_config(cfg_simvars_setup);
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
cfg_simvars_setup = get_beamformer_config_set('sim_vars_distr_src_paper_mismatched');
cfg_simvars_setup.data_file = data_files;
cfg_simvars_setup.force = force;
% cfg_simvars_setup.time_idx = time_idx;
cfg_simvars_setup.tag = '3sphere';
cfg_simvars_setup.head = [];
cfg_simvars_setup.head.current = hm_3sphere;
cfg_simvars_setup.head.actual = hm_bem;
cfg_simvars = get_beamformer_analysis_config(cfg_simvars_setup);
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
