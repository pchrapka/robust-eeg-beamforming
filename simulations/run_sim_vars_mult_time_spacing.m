%% run_sim_vars_mult_time_spacing.m
% Experimenting with different time spacings to model a multiple source
% scenario

clear all;
close all;
clc;

k = 1;
debug_flag = false;

%% set up head models
hmfactory = HeadModel();
hm_3sphere = hmfactory.createHeadModel('brainstorm','head_Default1_3sphere_500V.mat');
hm_bem = hmfactory.createHeadModel('brainstorm','head_Default1_bem_500V.mat');

%% Set up scripts to run

% Simulate ERP data
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t',...
    'sim_src_parameters',   'src_param_mult_cortical_source_9');
scripts(k).vars = {cfg};
k = k+1;

% Simulate ERP data
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t',...
    'sim_src_parameters',   'src_param_mult_cortical_source_10');
scripts(k).vars = {cfg};
k = k+1;

% Simulate ERP data
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t',...
    'sim_src_parameters',   'src_param_mult_cortical_source_11');
scripts(k).vars = {cfg};
k = k+1;
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
% 
% % Simulate ERP data
% scripts(k).func = @simulation_data;
% cfg = struct(...
%     'sim_data',             'sim_data_bem_1_100t',...
%     'sim_src_parameters',   'src_param_mult_cortical_source_15');
% scripts(k).vars = {cfg};
% k = k+1;

%% ==== mult_cort_src_9 ====
force = false;

% Data files
data_files = get_sim_data_files(...
    'sim','sim_data_bem_1_100t',...
    'source','mult_cort_src_9',...
    'iterations',1,...
    ...'snr',-20:10:0 ...
    ...'snr',-10:10:0 ...
    'snr',0 ...
    );

scripts(k).func = @sim_vars.run;
cfg_simvars_setup = get_beamformer_config_set('sim_vars_mult_src_basic_mismatched');
cfg_simvars_setup.data_file = data_files;
cfg_simvars_setup.force = force;
cfg_simvars_setup.tag = '3sphere';
cfg_simvars_setup.head.current = hm_3sphere;
cfg_simvars_setup.head.actual = hm_bem;
cfg_simvars = get_beamformer_analysis_config(cfg_simvars_setup);
cfg = struct(...
    'sim_vars',             cfg_simvars,...
    'analysis_run_func',    @beamformer_analysis,...
    'debug',                debug_flag);
scripts(k).vars = {cfg};
k = k+1;

%% ==== mult_cort_src_10 ====
force = false;

% Data files
data_files = get_sim_data_files(...
    'sim','sim_data_bem_1_100t',...
    'source','mult_cort_src_10',...
    'iterations',1,...
    ...'snr',-20:10:0 ...
    ...'snr',-10:10:0 ...
    'snr',0 ...
    );

scripts(k).func = @sim_vars.run;
cfg_simvars_setup = get_beamformer_config_set('sim_vars_mult_src_basic_mismatched');
cfg_simvars_setup.data_file = data_files;
cfg_simvars_setup.force = force;
cfg_simvars_setup.tag = '3sphere';
cfg_simvars_setup.head.current = hm_3sphere;
cfg_simvars_setup.head.actual = hm_bem;
cfg_simvars = get_beamformer_analysis_config(cfg_simvars_setup);
cfg = struct(...
    'sim_vars',             cfg_simvars,...
    'analysis_run_func',    @beamformer_analysis,...
    'debug',                debug_flag);
scripts(k).vars = {cfg};
k = k+1;

%% ==== mult_cort_src_11 ====
force = false;

% Data files
data_files = get_sim_data_files(...
    'sim','sim_data_bem_1_100t',...
    'source','mult_cort_src_11',...
    'iterations',1,...
    ...'snr',-20:10:0 ...
    'snr',-10:10:0 ...
    ...'snr',0 ...
    );

scripts(k).func = @sim_vars.run;
cfg_simvars_setup = get_beamformer_config_set('sim_vars_mult_src_basic_mismatched');
cfg_simvars_setup.data_file = data_files;
cfg_simvars_setup.force = force;
cfg_simvars_setup.tag = '3sphere';
cfg_simvars_setup.head.current = hm_3sphere;
cfg_simvars_setup.head.actual = hm_bem;
cfg_simvars = get_beamformer_analysis_config(cfg_simvars_setup);
cfg = struct(...
    'sim_vars',             cfg_simvars,...
    'analysis_run_func',    @beamformer_analysis,...
    'debug',                debug_flag);
scripts(k).vars = {cfg};
k = k+1;

% %% ==== mult_cort_src_12 ====
% force = false;
% 
% % Data files
% data_files = get_sim_data_files(...
%     'sim','sim_data_bem_1_100t',...
%     'source','mult_cort_src_12',...
%     'iterations',1,...
%     ...'snr',-20:10:0 ...
%     'snr',-10:10:0 ...
%     ...'snr',0 ...
%     );
% 
% scripts(k).func = @sim_vars.run;
% % cfg_simvars_setup = get_beamformer_config_set('sim_vars_mult_src_basic_mismatched');
% cfg_simvars_setup.data_file = data_files;
% cfg_simvars_setup.force = force;
% cfg_simvars_setup.tag = '3sphere';
% cfg_simvars_setup.head.current = hm_3sphere;
% cfg_simvars_setup.head.actual = hm_bem;
% cfg_simvars = get_beamformer_analysis_config(cfg_simvars_setup);
% cfg = struct(...
%     'sim_vars',             cfg_simvars,...
%     'analysis_run_func',    @beamformer_analysis,...
%     'debug',                debug_flag);
% scripts(k).vars = {cfg};
% k = k+1;
% 
% %% ==== mult_cort_src_13 ====
% force = false;
% 
% % Data files
% data_files = get_sim_data_files(...
%     'sim','sim_data_bem_1_100t',...
%     'source','mult_cort_src_13',...
%     'iterations',1,...
%     ...'snr',-20:10:0 ...
%     'snr',-10:10:0 ...
%     ...'snr',0 ...
%     );
% 
% scripts(k).func = @sim_vars.run;
% % cfg_simvars_setup = get_beamformer_config_set('sim_vars_mult_src_basic_mismatched');
% cfg_simvars_setup.data_file = data_files;
% cfg_simvars_setup.force = force;
% cfg_simvars_setup.tag = '3sphere';
% cfg_simvars_setup.head.current = hm_3sphere;
% cfg_simvars_setup.head.actual = hm_bem;
% cfg_simvars = get_beamformer_analysis_config(cfg_simvars_setup);
% cfg = struct(...
%     'sim_vars',             cfg_simvars,...
%     'analysis_run_func',    @beamformer_analysis,...
%     'debug',                debug_flag);
% scripts(k).vars = {cfg};
% k = k+1;
% 
% %% ==== mult_cort_src_14 ====
% force = false;
% 
% % Data files
% data_files = get_sim_data_files(...
%     'sim','sim_data_bem_1_100t',...
%     'source','mult_cort_src_14',...
%     'iterations',1,...
%     ...'snr',-20:10:0 ...
%     'snr',-10:10:0 ...
%     ...'snr',0 ...
%     );
% 
% scripts(k).func = @sim_vars.run;
% % cfg_simvars_setup = get_beamformer_config_set('sim_vars_mult_src_basic_mismatched');
% cfg_simvars_setup.data_file = data_files;
% cfg_simvars_setup.force = force;
% cfg_simvars_setup.tag = '3sphere';
% cfg_simvars_setup.head.current = hm_3sphere;
% cfg_simvars_setup.head.actual = hm_bem;
% cfg_simvars = get_beamformer_analysis_config(cfg_simvars_setup);
% cfg = struct(...
%     'sim_vars',             cfg_simvars,...
%     'analysis_run_func',    @beamformer_analysis,...
%     'debug',                debug_flag);
% scripts(k).vars = {cfg};
% k = k+1;
% 
% %% ==== mult_cort_src_15 ====
% force = false;
% 
% % Data files
% data_files = get_sim_data_files(...
%     'sim','sim_data_bem_1_100t',...
%     'source','mult_cort_src_15',...
%     'iterations',1,...
%     ...'snr',-20:10:0 ...
%     'snr',-10:10:0 ...
%     ...'snr',0 ...
%     );
% 
% scripts(k).func = @sim_vars.run;
% % cfg_simvars_setup = get_beamformer_config_set('sim_vars_mult_src_basic_mismatched');
% cfg_simvars_setup.data_file = data_files;
% cfg_simvars_setup.force = force;
% cfg_simvars_setup.tag = '3sphere';
% cfg_simvars_setup.head.current = hm_3sphere;
% cfg_simvars_setup.head.actual = hm_bem;
% cfg_simvars = get_beamformer_analysis_config(cfg_simvars_setup);
% cfg = struct(...
%     'sim_vars',             cfg_simvars,...
%     'analysis_run_func',    @beamformer_analysis,...
%     'debug',                debug_flag);
% scripts(k).vars = {cfg};
% k = k+1;

%% Run the scripts
aet_run_scripts( scripts );
