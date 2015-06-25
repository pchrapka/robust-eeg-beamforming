%% run_all
util.update_aet();
% Initialize the Advanced EEG Toolbox
aet_init

%% Open the parallel pipeline
aet_parallel_init([]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Running time: approx. 30 minutes for one analysis (one snr, matched and
% mismatched scenarios and RMVB included)

%% Paper simulations
% PAPER
% run_sim_vars_single_bem_paper
% run_sim_vars_distr_bem_paper
run_sim_vars_bem_paper_mult17

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% SINR
% Calculate SINR for different source configurations
% PAPER
metric_analysis_sinr

%% Close the parallel pipeline
aet_parallel_close([]);


