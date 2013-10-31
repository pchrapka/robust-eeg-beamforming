%% run_sim_vars.m -- Script for running different analysis variations 

clear all;
close all;
clc;

%% Update AET, just in case
update_aet()

%% Initialize the Advanced EEG Toolbox
aet_init
k = 1;

%% Set up scripts to run


% scripts(k).func = @simulation_data;
% cfg = struct(...
%     'sim_data',             'sim_data_test',...
%     'sim_src_parameters',   'src_param_mult_cortical_source_3');
% scripts(k).vars = {cfg};
% k = k+1;

%% Parameter sweep

% FIXME Still need somewhere to save the file
scripts(k).func = @sim_vars.run;
cfg = struct(...
    'sim_vars',             sim_vars.get_config('sim_vars_test'),...
    'analysis_run_func',    @beamformer_analysis);
scripts(k).vars = {cfg};
k = k+1;

%% Run the scripts
aet_run_scripts( scripts );