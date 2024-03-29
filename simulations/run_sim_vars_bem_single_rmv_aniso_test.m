%% run_sim_vars_bem_single_rmv_aniso_test
% Script for running different analysis variations 

clear all;
close all;
clc;

k = 1;

%% set up head models
hmfactory = HeadModel();
hm_3sphere = hmfactory.createHeadModel('brainstorm','head_Default1_3sphere_500V.mat');
hm_bem = hmfactory.createHeadModel('brainstorm','head_Default1_bem_500V.mat');

%% Set up scripts to run

% % Simulate ERP data
% scripts(k).func = @simulation_data;
% cfg = struct(...
%     'sim_data',             'sim_data_bem_1_100t_1000s',...
%     'sim_src_parameters',   'src_param_single_cortical_source_1',...
%     'snr_range',            -20:10:20 ...
%     );
% scripts(k).vars = {cfg};
% k = k+1;

%% Parameter sweep
force = false;

% Data files
data_files = get_sim_data_files(...
    'sim','sim_data_bem_1_100t_1000s',...
    'source','single_cort_src_1',...
    'iterations',1,...
    ...'snr',-20:10:0 ...
    'snr',-10:10:0 ...
    ...'snr',0 ...
    );

%% ==== MISMATCHED LEADFIELD ====

scripts(k).func = @sim_vars.run;
cfg_simvars_setup = get_beamformer_config_set('sim_vars_test_rmv_aniso');
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
    'debug',                true);
scripts(k).vars = {cfg};
k = k+1;

%% Run the scripts
aet_run_scripts( scripts );
