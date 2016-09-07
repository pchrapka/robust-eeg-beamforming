%% run_sim_vars_mult_bem_paper_lags.m
% Same run_sim_vars_mult_bem_paper except with more temporal spacing

clear all;
close all;
clc;

k = 1;

%% Set up scripts to run

%% ==== ERP SIMULATION ====

param_files = {...
    'src_param_mult_cortical_source_17_lag4',...
    'src_param_mult_cortical_source_17_lag8',...
    'src_param_mult_cortical_source_17_lag12',...
    'src_param_mult_cortical_source_17_lag16',...
    'src_param_mult_cortical_source_17_lag20'};

for j=1:length(param_files)
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t',...
    'sim_src_parameters',   param_files{j},...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;
end


%% Parameter sweep
force = false;

%% Data files
cfg_data = [];
cfg_data.data_name = 'sim_data_bem_1_100t';
cfg_data.source_names = {...
    'mult_cort_src_17_lag4',...
    'mult_cort_src_17_lag8',...
    'mult_cort_src_17_lag12',...
    'mult_cort_src_17_lag16',...
    'mult_cort_src_17_lag20'
    };
cfg_data.iteration_range = 1;
cfg_data.snr_range = 0;%-10:10:0;%-20:10:0;

%% ==== MATCHED LEADFIELD ====

for j=1:length(cfg_data.source_names)
    cfg_data.source_name = cfg_data.source_names{j};
    scripts(k).func = @sim_vars.run;
    cfg_simvars_setup = [];
    cfg_simvars_setup.id = 'sim_vars_mult_src_paper_matched';
    cfg_simvars_setup.data = cfg_data;
    cfg_simvars_setup.force = force;
    cfg_simvars_setup.head.type = 'brainstorm';
    cfg_simvars_setup.head.file = 'head_Default1_bem_500V.mat';
    cfg_simvars = sim_vars.get_config(cfg_simvars_setup);
    cfg = struct(...
        'sim_vars',             cfg_simvars,...
        'analysis_run_func',    @beamformer_analysis,...
        ...Allow parallel execution of the scans
        'parallel',             false,...
        'debug',                false);
    scripts(k).vars = {cfg};
    k = k+1;
end

%% ==== MISMATCHED LEADFIELD ====

for j=1:length(cfg_data.source_names)
    cfg_data.source_name = cfg_data.source_names{j};
    scripts(k).func = @sim_vars.run;
    cfg_simvars_setup = [];
    cfg_simvars_setup.id = 'sim_vars_mult_src_paper_mismatched';
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
        ...Allow parallel execution of the scans
        'parallel',             false,...
        'debug',                false);
    scripts(k).vars = {cfg};
    k = k+1;
end

%% Run the scripts
aet_run_scripts( scripts );