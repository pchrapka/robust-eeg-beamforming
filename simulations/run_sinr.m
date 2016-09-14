%% run_sinr


%% data and beamformers

run_sim_vars_bem_paper_mult17_lag40
run_sim_vars_bem_paper_mult_sine
run_sim_vars_bem_paper_mult_sine_uncor

%% sinr metrics

metric_analysis_sinr_mult('mult_cort_src_sine_2');
metric_analysis_sinr_mult('mult_cort_src_17_lag40');
metric_analysis_sinr_mult('mult_cort_src_sine_2_uncor');