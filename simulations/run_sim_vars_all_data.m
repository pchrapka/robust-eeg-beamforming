%% run_sim_vars_all_data
% Generates all the simulation data for sim_data_bem_1_100t

clear all;
close all;
clc;

k = 1;

%% Set up scripts to run

% Simulate ERP data
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t',...
    'sim_src_parameters',   'src_param_distr_cortical_source_3',...
    'snr_range',            -20:10:20 ...
);
scripts(k).vars = {cfg};
k = k+1;

%% Run the scripts
aet_run_scripts( scripts );