%% run_sim_vars_bem_mult17_lag40_locs2_pinvvariations
%
%   Summary:
%   - uncorrelated ERPs, temporally non-overlapping
%   - lcmv pinv variations
%   

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
    'sim_src_parameters',   'src_param_mult_cortical_source_17_lag40',...
    'snr_range',            -20:10:20,...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

%% Parameter sweep
force = false;

data_files = get_sim_data_files(...
    'sim','sim_data_bem_1_100t',...
    'source','mult_cort_src_17_lag40',...
    'iterations',1,...
    'snr',-20:10:20 ...
    );

%% ==== MATCHED LEADFIELD ====

% scripts(k).func = @sim_vars.run;
% cfg_simvars_setup = get_beamformer_config_set('');
% cfg_simvars_setup.data_file = data_files;
% cfg_simvars_setup.force = force;
% cfg_simvars_setup.head = hm_bem;
% cfg_simvars_setup.loc = [295,400];
% cfg_simvars_setup.tag = 'locs2';
% cfg_simvars = get_beamformer_analysis_config(cfg_simvars_setup);
% 
% cfg = struct(...
%     'sim_vars',             cfg_simvars,...
%     'analysis_run_func',    @beamformer_analysis,...
%     ...Allow parallel execution of the scans
%     'parallel',             false,...
%     'debug',                false);
% scripts(k).vars = {cfg};
% k = k+1;

%% ==== MISMATCHED LEADFIELD ====

scripts(k).func = @sim_vars.run;
cfg_simvars_setup = get_beamformer_config_set('sim_vars_mult_src_pinv_variations_mismatched');
cfg_simvars_setup.data_file = data_files;
cfg_simvars_setup.force = force;
cfg_simvars_setup.tag = 'locs2_3sphere';
cfg_simvars_setup.head = [];
cfg_simvars_setup.head.current = hm_3sphere;
cfg_simvars_setup.head.actual = hm_bem;
cfg_simvars_setup.loc = [295,400];
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

%% Computer sin
metric_analysis_sinr_mult17_lag40_pinvvariations