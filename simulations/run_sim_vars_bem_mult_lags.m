%% run_sim_vars_bem_mult_lags
% Same run_sim_vars_mult_bem_paper except with more temporal spacing

clear all;
close all;
clc;

k = 1;

%% set up head models
hmfactory = HeadModel();
hm_3sphere = hmfactory.createHeadModel('brainstorm','head_Default1_3sphere_500V.mat');
hm_bem = hmfactory.createHeadModel('brainstorm','head_Default1_bem_500V.mat');

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
        'sim_data',             'sim_data_bem_1_100t_1000s',...
        'sim_src_parameters',   param_files{j},...
        'snr_range',            -20:10:20,...
        ...Allow aet_sim_eeg_avg to parallelize the trials
        'parallel',             false);
    scripts(k).vars = {cfg};
    k = k+1;
end


%% Parameter sweep
force = false;

%% Data files
source_names = {...
    'mult_cort_src_17_lag4',...
    'mult_cort_src_17_lag8',...
    'mult_cort_src_17_lag12',...
    'mult_cort_src_17_lag16',...
    'mult_cort_src_17_lag20'
    };

%% ==== MATCHED LEADFIELD ====

for j=1:length(source_names)
    data_files = get_sim_data_files(...
        'sim','sim_data_bem_1_100t_1000s',...
        'source',source_names{j},...
        'iterations',1,...
        ...'snr',-20:10:0 ...
        ...'snr',-10:10:0 ...
        'snr',0 ...
        );
   
    scripts(k).func = @sim_vars.run;
        cfg_simvars_setup = get_beamformer_config_set('sim_vars_mult_src_extended_matched');
    cfg_simvars_setup.data_file = data_files;
    cfg_simvars_setup.force = force;
    cfg_simvars_setup.head = hm_bem;
    cfg_simvars = get_beamformer_analysis_config(cfg_simvars_setup);
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

for j=1:length(source_names)
    data_files = get_sim_data_files(...
        'sim','sim_data_bem_1_100t_1000s',...
        'source',source_names{j},...
        'iterations',1,...
        ...'snr',-20:10:0 ...
        ...'snr',-10:10:0 ...
        'snr',0 ...
        );
    
    scripts(k).func = @sim_vars.run;
        cfg_simvars_setup = get_beamformer_config_set('sim_vars_mult_src_extended_mismatched');
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
        ...Allow parallel execution of the scans
        'parallel',             false,...
        'debug',                false);
    scripts(k).vars = {cfg};
    k = k+1;
end

%% Run the scripts
aet_run_scripts( scripts );
