%% run_all

%% Open the parallel pipeline
% set up parallel execution
lumberjack.parfor_setup();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Running time: approx. 30 minutes for one analysis (one snr, matched and
% mismatched scenarios and RMVB included)

%% Run all simulations
% run_sim_vars_single
% run_sim_vars_mult
% run_sim_vars_distr

%% Run all BEM simulations
% run_sim_vars_bem_single
% run_sim_vars_bem_mult
% run_sim_vars_bem_distr

%% Paper simulations
% PAPER
run_sim_vars_bem_single_paper
run_sim_vars_bem_mult10
% run_sim_vars_bem_distr_paper
run_sim_vars_bem_mult17
run_sim_vars_bem_mult17_lag8

%% Mult src spacing
% run_sim_vars_single_test
% run_sim_vars_mult_time_spacing
% run_sim_vars_bem_mult_lags

%% Sacrifice with RMVB
% run_sim_vars_bem_single_paper_2

%% Sinusoidal sources
% run_sim_vars_bem_mult_sine
% run_sim_vars_bem_mult_sine_uncor

%% Complex ERP sources
% run_sim_vars_bem_single_paper_complex
% run_sim_vars_bem_mult_complex

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% RMS analysis with multiple iterations
% WARNING: Running time approx. 30 hours for one
% run_rms

%% RMS
% rms_analysis_iter1_mult_paper_all

%% All Metrics
% metric_analysis_iter1_mult_paper_all

%% SINR
% Calculate SINR for different source configurations
% PAPER
metric_analysis_sinr


