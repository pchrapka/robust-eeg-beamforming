%% run_all

%% Open the parallel pipeline
aet_parallel_init([]);

%% Run all simulations
% run_sim_vars_single
% run_sim_vars_mult
% run_sim_vars_distr

%% Run all BEM simulations
% run_sim_vars_single_bem
% run_sim_vars_mult_bem
% run_sim_vars_distr_bem

%% Paper simulations
% run_sim_vars_single_bem_paper
run_sim_vars_mult_bem_paper % mult10
% run_sim_vars_distr_bem_paper
run_sim_vars_mult_bem_paper_2 % mult17

%% Mult src spacing
% run_sim_vars_single_test
% run_sim_vars_mult_time_spacing
% run_sim_vars_mult_bem_paper_lags

%% RMS analysis
% Multiple iterations: Running time approx. 30 hours for one
% run_rms

%% Sacrifice with RMVB
% run_sim_vars_single_bem_paper_2

%% Sinusoidal sources
% run_sim_vars_mult_sine_bem_paper

%% Complex ERP sources
% run_sim_vars_single_bem_paper_complex
run_sim_vars_mult_bem_paper_complex

%% Close the parallel pipeline
aet_parallel_close([]);


