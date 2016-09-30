%% run_sim_vars_bem_distr_data

clear all;
close all;
clc;

%% Open the parallel pipeline
% set up parallel execution
lumberjack.parfor_setup();
k = 1;

%% Set up scripts to run

% Simulate ERP data
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t',...
    'sim_src_parameters',   'src_param_distr_cortical_source_2',...
    'snr_range',            -20:10:20,...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

% Simulate ERP data
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t',...
    'sim_src_parameters',   'src_param_distr_cortical_source_2_point',...
    'snr_range',            -20:10:20,...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

% Simulate ERP data
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t',...
    'sim_src_parameters',   'src_param_distr_cortical_source_3',...
    'snr_range',            -20:10:20,...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

% Simulate ERP data
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t',...
    'sim_src_parameters',   'src_param_distr_cortical_source_complex_1',...
    'snr_range',            -20:10:20,...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

% Simulate ERP data
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t',...
    'sim_src_parameters',   'src_param_distr_cortical_source_complex_2',...
    'snr_range',            -20:10:20,...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

%% Run the scripts
aet_run_scripts( scripts );