%% run_sinr


%% data and beamformers

run_sim_vars_bem_mult17_lag40
run_sim_vars_bem_mult_sine
run_sim_vars_bem_mult_sine_uncor
% run_sim_vars_bem_mult17_covtrial

%% sinr metrics

metric_analysis_sinr_mult('sim_data_bem_1_100t_1000s', 'mult_cort_src_sine_2');
metric_analysis_sinr_mult('sim_data_bem_1_100t_1000s', 'mult_cort_src_17_lag40');
metric_analysis_sinr_mult('sim_data_bem_1_100t_1000s', 'mult_cort_src_sine_2_uncor');
% metric_analysis_sinr_mult('sim_data_bem_1_1000t_noavg', 'mult_cort_src_17_randamp');
