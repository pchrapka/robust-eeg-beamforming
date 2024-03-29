%% run_sim_vars_source_configs
% Script to generate data for source configs

clear all;
close all;
clc;

k = 1;

%% Set up scripts to run

%% src_param_mult_cortical_source_10
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t_1000s',...
    'sim_src_parameters',   'src_param_mult_cortical_source_10',...
    'snr_range',            -20:10:20,...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

%% src_param_mult_cortical_source_17
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t_1000s',...
    'sim_src_parameters',   'src_param_mult_cortical_source_17',...
    'snr_range',            -20:10:20,...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

%% src_param_mult_cortical_source_sine_2
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t_1000s',...
    'sim_src_parameters',   'src_param_mult_cortical_source_sine_2',...
    'snr_range',            -20:10:20,...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

%% src_param_distr_cortical_source_2
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t_1000s',...
    'sim_src_parameters',   'src_param_distr_cortical_source_2',...
    'snr_range',            -20:10:20,...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

%% src_param_distr_cortical_source_3
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t_1000s',...
    'sim_src_parameters',   'src_param_distr_cortical_source_3',...
    'snr_range',            -20:10:20,...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

%% src_param_single_cortical_source_1
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t_1000s',...
    'sim_src_parameters',   'src_param_single_cortical_source_1',...
    'snr_range',            -20:10:20,...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

%% src_param_single_cortical_source_complex_1
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t_1000s',...
    'sim_src_parameters',   'src_param_single_cortical_source_complex_1',...
    'snr_range',            -20:10:20,...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

%% src_param_single_cortical_source_complex_2
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t_1000s',...
    'sim_src_parameters',   'src_param_single_cortical_source_complex_2',...
    'snr_range',            -20:10:20,...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

%% src_param_single_cortical_source_complex_2_freq
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t_1000s',...
    'sim_src_parameters',   'src_param_single_cortical_source_complex_2_freq',...
    'snr_range',            -20:10:20,...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

%% src_param_single_cortical_source_complex_2_dip
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t_1000s',...
    'sim_src_parameters',   'src_param_single_cortical_source_complex_2_dip',...
    'snr_range',            -20:10:20,...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

%% src_param_mult_cortical_source_complex_1
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t_1000s',...
    'sim_src_parameters',   'src_param_mult_cortical_source_complex_1',...
    'snr_range',            -20:10:20,...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

%% src_param_mult_cortical_source_complex_1_freq
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t_1000s',...
    'sim_src_parameters',   'src_param_mult_cortical_source_complex_1_freq',...
    'snr_range',            -20:10:20,...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

%% src_param_mult_cortical_source_complex_1_freq_pos
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t_1000s',...
    'sim_src_parameters',   'src_param_mult_cortical_source_complex_1_freq_pos',...
    'snr_range',            -20:10:20,...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

%% src_param_mult_cortical_source_complex_1_dip
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t_1000s',...
    'sim_src_parameters',   'src_param_mult_cortical_source_complex_1_dip',...
    'snr_range',            -20:10:20,...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

%% src_param_mult_cortical_source_complex_1_dip_pos
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t_1000s',...
    'sim_src_parameters',   'src_param_mult_cortical_source_complex_1_dip_pos',...
    'snr_range',            -20:10:20,...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

%% src_param_mult_cortical_source_complex_1_pos
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t_1000s',...
    'sim_src_parameters',   'src_param_mult_cortical_source_complex_1_pos',...
    'snr_range',            -20:10:20,...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

%% src_param_mult_cortical_source_complex_1_pos_exact
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t_1000s',...
    'sim_src_parameters',   'src_param_mult_cortical_source_complex_1_pos_exact',...
    'snr_range',            -20:10:20,...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

%% src_param_mult_cortical_source_complex_2_pos_exact
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t_1000s',...
    'sim_src_parameters',   'src_param_mult_cortical_source_complex_2_pos_exact',...
    'snr_range',            -20:10:20,...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

%% src_param_distr_cortical_source_complex_1
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t_1000s',...
    'sim_src_parameters',   'src_param_distr_cortical_source_complex_1',...
    'snr_range',            -20:10:20,...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

%% src_param_distr_cortical_source_complex_2
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t_1000s',...
    'sim_src_parameters',   'src_param_distr_cortical_source_complex_2',...
    'snr_range',            -20:10:20,...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

%% src_param_single_cortical_source_erp_sine_exp_1
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t_1000s',...
    'sim_src_parameters',   'src_param_single_cortical_source_erp_sine_exp_1',...
    'snr_range',            -20:10:20,...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

%% src_param_single_cortical_source_biphasic_1
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             'sim_data_bem_1_100t_1000s',...
    'sim_src_parameters',   'src_param_single_cortical_source_biphasic_1',...
    'snr_range',            -20:10:20,...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

%% Run the scripts
% set up parallel execution
lumberjack.parfor_setup();

aet_run_scripts( scripts );
