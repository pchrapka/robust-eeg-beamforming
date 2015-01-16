clear all;
close all;
clc;

%% Update AET, just in case
util.update_aet();

%% Initialize the Advanced EEG Toolbox
aet_init
% Open the parallel pipeline
aet_parallel_init([]);
k = 1;

%% Set up scripts to run

% Simulate ERP data
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t',...
    'sim_src_parameters',   'src_param_distr_cortical_source_2',...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

% Simulate ERP data
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t',...
    'sim_src_parameters',   'src_param_distr_cortical_source_2_point',...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

% Simulate ERP data
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t',...
    'sim_src_parameters',   'src_param_distr_cortical_source_3',...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

% Simulate ERP data
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t',...
    'sim_src_parameters',   'src_param_distr_cortical_source_complex_1',...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

% Simulate ERP data
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t',...
    'sim_src_parameters',   'src_param_distr_cortical_source_complex_2',...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

%% Run the scripts
aet_run_scripts( scripts );