%% run_sim_vars_mult_time_spacing.m
% Experimenting with different time spacings to model a multiple source
% scenario

clear all;
close all;
clc;

%% Update AET, just in case
update_aet()

%% Initialize the Advanced EEG Toolbox
aet_init
k = 1;
debug_flag = false;

%% Set up scripts to run

% % Simulate ERP data
% scripts(k).func = @simulation_data;
% cfg = struct(...
%     'sim_data',             'sim_data_bem_1_100t',...
%     'sim_src_parameters',   'src_param_mult_cortical_source_9');
% scripts(k).vars = {cfg};
% k = k+1;
% 
% % Simulate ERP data
% scripts(k).func = @simulation_data;
% cfg = struct(...
%     'sim_data',             'sim_data_bem_1_100t',...
%     'sim_src_parameters',   'src_param_mult_cortical_source_10');
% scripts(k).vars = {cfg};
% k = k+1;
% 
% % Simulate ERP data
% scripts(k).func = @simulation_data;
% cfg = struct(...
%     'sim_data',             'sim_data_bem_1_100t',...
%     'sim_src_parameters',   'src_param_mult_cortical_source_11');
% scripts(k).vars = {cfg};
% k = k+1;
% 
% % Simulate ERP data
% scripts(k).func = @simulation_data;
% cfg = struct(...
%     'sim_data',             'sim_data_bem_1_100t',...
%     'sim_src_parameters',   'src_param_mult_cortical_source_12');
% scripts(k).vars = {cfg};
% k = k+1;
% 
% % Simulate ERP data
% scripts(k).func = @simulation_data;
% cfg = struct(...
%     'sim_data',             'sim_data_bem_1_100t',...
%     'sim_src_parameters',   'src_param_mult_cortical_source_13');
% scripts(k).vars = {cfg};
% k = k+1;
% 
% % Simulate ERP data
% scripts(k).func = @simulation_data;
% cfg = struct(...
%     'sim_data',             'sim_data_bem_1_100t',...
%     'sim_src_parameters',   'src_param_mult_cortical_source_14');
% scripts(k).vars = {cfg};
% k = k+1;

% Simulate ERP data
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t',...
    'sim_src_parameters',   'src_param_mult_cortical_source_15');
scripts(k).vars = {cfg};
k = k+1;

%% ==== mult_cort_src_9 ====
force = false;

% Data files
cfg_data = [];
cfg_data.data_name = 'sim_data_bem_1_100t';
cfg_data.source_name = 'mult_cort_src_9';
cfg_data.iteration_range = 1;
cfg_data.snr_range = -10:10:0;%-20:10:0;

scripts(k).func = @sim_vars.run;
cfg_simvars_setup = [];
cfg_simvars_setup.id = 'sim_vars_mult_src_basic_mismatched';
cfg_simvars_setup.data = cfg_data;
cfg_simvars_setup.force = force;
cfg_simvars_setup.tag = '3sphere';
cfg_simvars_setup.head.current.type = 'brainstorm';
cfg_simvars_setup.head.current.file = 'head_Default1_3sphere_500V.mat';
cfg_simvars_setup.head.actual.type = 'brainstorm';
cfg_simvars_setup.head.actual.file = 'head_Default1_bem_500V.mat';
cfg_simvars = sim_vars.get_config(cfg_simvars_setup);
cfg = struct(...
    'sim_vars',             cfg_simvars,...
    'analysis_run_func',    @beamformer_analysis,...
    'debug',                debug_flag);
scripts(k).vars = {cfg};
k = k+1;

%% ==== mult_cort_src_10 ====
force = false;

% Data files
cfg_data = [];
cfg_data.data_name = 'sim_data_bem_1_100t';
cfg_data.source_name = 'mult_cort_src_10';
cfg_data.iteration_range = 1;
cfg_data.snr_range = -10:10:0;%-20:10:0;

scripts(k).func = @sim_vars.run;
cfg_simvars_setup = [];
cfg_simvars_setup.id = 'sim_vars_mult_src_basic_mismatched';
cfg_simvars_setup.data = cfg_data;
cfg_simvars_setup.force = force;
cfg_simvars_setup.tag = '3sphere';
cfg_simvars_setup.head.current.type = 'brainstorm';
cfg_simvars_setup.head.current.file = 'head_Default1_3sphere_500V.mat';
cfg_simvars_setup.head.actual.type = 'brainstorm';
cfg_simvars_setup.head.actual.file = 'head_Default1_bem_500V.mat';
cfg_simvars = sim_vars.get_config(cfg_simvars_setup);
cfg = struct(...
    'sim_vars',             cfg_simvars,...
    'analysis_run_func',    @beamformer_analysis,...
    'debug',                debug_flag);
scripts(k).vars = {cfg};
k = k+1;

%% ==== mult_cort_src_11 ====
force = false;

% Data files
cfg_data = [];
cfg_data.data_name = 'sim_data_bem_1_100t';
cfg_data.source_name = 'mult_cort_src_11';
cfg_data.iteration_range = 1;
cfg_data.snr_range = -10:10:0;%-20:10:0;

scripts(k).func = @sim_vars.run;
cfg_simvars_setup = [];
cfg_simvars_setup.id = 'sim_vars_mult_src_basic_mismatched';
cfg_simvars_setup.data = cfg_data;
cfg_simvars_setup.force = force;
cfg_simvars_setup.tag = '3sphere';
cfg_simvars_setup.head.current.type = 'brainstorm';
cfg_simvars_setup.head.current.file = 'head_Default1_3sphere_500V.mat';
cfg_simvars_setup.head.actual.type = 'brainstorm';
cfg_simvars_setup.head.actual.file = 'head_Default1_bem_500V.mat';
cfg_simvars = sim_vars.get_config(cfg_simvars_setup);
cfg = struct(...
    'sim_vars',             cfg_simvars,...
    'analysis_run_func',    @beamformer_analysis,...
    'debug',                debug_flag);
scripts(k).vars = {cfg};
k = k+1;

%% ==== mult_cort_src_12 ====
force = false;

% Data files
cfg_data = [];
cfg_data.data_name = 'sim_data_bem_1_100t';
cfg_data.source_name = 'mult_cort_src_12';
cfg_data.iteration_range = 1;
cfg_data.snr_range = -10:10:0;%-20:10:0;

scripts(k).func = @sim_vars.run;
cfg_simvars_setup = [];
cfg_simvars_setup.id = 'sim_vars_mult_src_basic_mismatched';
cfg_simvars_setup.data = cfg_data;
cfg_simvars_setup.force = force;
cfg_simvars_setup.tag = '3sphere';
cfg_simvars_setup.head.current.type = 'brainstorm';
cfg_simvars_setup.head.current.file = 'head_Default1_3sphere_500V.mat';
cfg_simvars_setup.head.actual.type = 'brainstorm';
cfg_simvars_setup.head.actual.file = 'head_Default1_bem_500V.mat';
cfg_simvars = sim_vars.get_config(cfg_simvars_setup);
cfg = struct(...
    'sim_vars',             cfg_simvars,...
    'analysis_run_func',    @beamformer_analysis,...
    'debug',                debug_flag);
scripts(k).vars = {cfg};
k = k+1;

%% ==== mult_cort_src_13 ====
force = false;

% Data files
cfg_data = [];
cfg_data.data_name = 'sim_data_bem_1_100t';
cfg_data.source_name = 'mult_cort_src_13';
cfg_data.iteration_range = 1;
cfg_data.snr_range = -10:10:0;%-20:10:0;

scripts(k).func = @sim_vars.run;
cfg_simvars_setup = [];
cfg_simvars_setup.id = 'sim_vars_mult_src_basic_mismatched';
cfg_simvars_setup.data = cfg_data;
cfg_simvars_setup.force = force;
cfg_simvars_setup.tag = '3sphere';
cfg_simvars_setup.head.current.type = 'brainstorm';
cfg_simvars_setup.head.current.file = 'head_Default1_3sphere_500V.mat';
cfg_simvars_setup.head.actual.type = 'brainstorm';
cfg_simvars_setup.head.actual.file = 'head_Default1_bem_500V.mat';
cfg_simvars = sim_vars.get_config(cfg_simvars_setup);
cfg = struct(...
    'sim_vars',             cfg_simvars,...
    'analysis_run_func',    @beamformer_analysis,...
    'debug',                debug_flag);
scripts(k).vars = {cfg};
k = k+1;

%% ==== mult_cort_src_14 ====
force = false;

% Data files
cfg_data = [];
cfg_data.data_name = 'sim_data_bem_1_100t';
cfg_data.source_name = 'mult_cort_src_14';
cfg_data.iteration_range = 1;
cfg_data.snr_range = -10:10:0;%-20:10:0;

scripts(k).func = @sim_vars.run;
cfg_simvars_setup = [];
cfg_simvars_setup.id = 'sim_vars_mult_src_basic_mismatched';
cfg_simvars_setup.data = cfg_data;
cfg_simvars_setup.force = force;
cfg_simvars_setup.tag = '3sphere';
cfg_simvars_setup.head.current.type = 'brainstorm';
cfg_simvars_setup.head.current.file = 'head_Default1_3sphere_500V.mat';
cfg_simvars_setup.head.actual.type = 'brainstorm';
cfg_simvars_setup.head.actual.file = 'head_Default1_bem_500V.mat';
cfg_simvars = sim_vars.get_config(cfg_simvars_setup);
cfg = struct(...
    'sim_vars',             cfg_simvars,...
    'analysis_run_func',    @beamformer_analysis,...
    'debug',                debug_flag);
scripts(k).vars = {cfg};
k = k+1;

%% ==== mult_cort_src_15 ====
force = false;

% Data files
cfg_data = [];
cfg_data.data_name = 'sim_data_bem_1_100t';
cfg_data.source_name = 'mult_cort_src_15';
cfg_data.iteration_range = 1;
cfg_data.snr_range = -10:10:0;%-20:10:0;

scripts(k).func = @sim_vars.run;
cfg_simvars_setup = [];
cfg_simvars_setup.id = 'sim_vars_mult_src_basic_mismatched';
cfg_simvars_setup.data = cfg_data;
cfg_simvars_setup.force = force;
cfg_simvars_setup.tag = '3sphere';
cfg_simvars_setup.head.current.type = 'brainstorm';
cfg_simvars_setup.head.current.file = 'head_Default1_3sphere_500V.mat';
cfg_simvars_setup.head.actual.type = 'brainstorm';
cfg_simvars_setup.head.actual.file = 'head_Default1_bem_500V.mat';
cfg_simvars = sim_vars.get_config(cfg_simvars_setup);
cfg = struct(...
    'sim_vars',             cfg_simvars,...
    'analysis_run_func',    @beamformer_analysis,...
    'debug',                debug_flag);
scripts(k).vars = {cfg};
k = k+1;

%% Run the scripts
aet_run_scripts( scripts );