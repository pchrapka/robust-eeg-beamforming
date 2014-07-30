%% run_sim_vars.m -- Script for running different analysis variations 
% Same as run_sim_vars_mult_bem_paper_rms except with more temporal spacing
% between sources

clear all;
close all;
clc;

%% Update AET, just in case
util.update_aet();

%% Initialize the Advanced EEG Toolbox
aet_init
k = 1;

%% Set up scripts to run

% Simulate ERP data
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_100_100t',...
    'sim_src_parameters',   'src_param_mult_cortical_source_14');
scripts(k).vars = {cfg};
k = k+1;

%% Parameter sweep
force = false;
% 0.460 comes from the time point selected for display in the paper
% time_idx = 250*0.460;
% time_idx won't work for two times

% Data files
cfg_data = [];
cfg_data.data_name = 'sim_data_bem_100_100t';
cfg_data.source_name = 'mult_cort_src_14';
cfg_data.iteration_range = 1:100;
cfg_data.snr_range = 0;

%% ==== MATCHED LEADFIELD ====

scripts(k).func = @sim_vars.run;
cfg_simvars_setup = [];
cfg_simvars_setup.id = 'sim_vars_mult_src_paper_matched';
cfg_simvars_setup.data = cfg_data;
cfg_simvars_setup.force = force;
% cfg_simvars_setup.time_idx = time_idx;
cfg_simvars_setup.head.type = 'brainstorm';
cfg_simvars_setup.head.file = 'head_Default1_bem_500V.mat';
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
cfg_simvars_setup.id = 'sim_vars_mult_src_paper_mismatched';
cfg_simvars_setup.data = cfg_data;
cfg_simvars_setup.force = force;
% cfg_simvars_setup.time_idx = time_idx;
cfg_simvars_setup.tag = '3sphere';
cfg_simvars_setup.head.current.type = 'brainstorm';
cfg_simvars_setup.head.current.file = 'head_Default1_3sphere_500V.mat';
cfg_simvars_setup.head.actual.type = 'brainstorm';
cfg_simvars_setup.head.actual.file = 'head_Default1_bem_500V.mat';
cfg_simvars = sim_vars.get_config(cfg_simvars_setup);
cfg = struct(...
    'sim_vars',             cfg_simvars,...
    'analysis_run_func',    @beamformer_analysis);
scripts(k).vars = {cfg};
k = k+1;

%% Run the scripts
aet_run_scripts( scripts );