%% run_sim_vars_all_data
% Generates all the simulation data for sim_data_bem_1_100t

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
    'sim_data',             'sim_data_bem_1_100t',...
    'sim_src_parameters',   'src_param_distr_cortical_source_3');
scripts(k).vars = {cfg};
k = k+1;

%% Run the scripts
aet_run_scripts( scripts );