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

% run_sim_vars_single_bem_paper
% run_sim_vars_distr_bem_paper
run_sim_vars_bem_paper_mult17


% HD for beampatterns and power plots
% run_sim_vars_bemhd_paper_mult17hd

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% SINR
% Calculate SINR for mult source configuration
metric_analysis_sinr_mult_paper

%% Power plots at t=t1

% low res
% TODO have data, redo script using beampattern as example
% single
% distr
% mult

% high res
% TODO simulate data for single and distr
% single
% distr
% mult

%% Close the parallel pipeline
aet_parallel_close([]);


