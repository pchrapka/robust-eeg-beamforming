%% run_sim_vars.m -- Script for running different analysis variations 

clear all;
close all;
clc;

k = 1;

%% Set up scripts to run


% scripts(k).func = @simulation_data;
% cfg = struct(...
%     'sim_data',             'sim_data_2',...
%     'sim_src_parameters',   'src_param_mult_cortical_source_4');
% scripts(k).vars = {cfg};
% k = k+1;

%% Parameter sweep

force = false;

% Data files
data_files = get_sim_data_files(...
    'sim','sim_data_2',...
    'source','mult_cort_src_4',...
    'iterations',1,...
    'snr',-40:5:25 ...
    );

% FIXME Still need somewhere to save the file
% scripts(k).func = @sim_vars.run;
% cfg = struct(...
%     'sim_vars',             sim_vars.get_config('sim_vars_lcmv',cfg_data,force),...
%     'analysis_run_func',    @beamformer_analysis);
% scripts(k).vars = {cfg};
% k = k+1;

scripts(k).func = @sim_vars.run;
cfg_simvars_setup = [];
cfg_simvars_setup.id = 'sim_vars_rmv';
cfg_simvars_setup.data_file = data_files;
cfg_simvars_setup.force = force;
cfg_simvars = sim_var.get_config(cfg_simvars_setup);
cfg = struct(...
    'sim_vars',             cfg_simvars,...
    'analysis_run_func',    @beamformer_analysis);
scripts(k).vars = {cfg};
k = k+1;

%% Run the scripts
aet_run_scripts( scripts );