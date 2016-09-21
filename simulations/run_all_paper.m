%% run_all_paper

%% Open the parallel pipeline
% set up parallel execution
lumberjack.parfor_setup();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Running time: approx. 30 minutes for one analysis (one snr, matched and
% mismatched scenarios and RMVB included)

% Low res simulations for Output SINR vs Input SNR
run_sim_vars_single_bem_paper
run_sim_vars_distr_bem_paper
% run_sim_vars_bem_mult17 % old - too correlated
run_sim_vars_bem_mult17_lag40_locs2

% HD for beampatterns and power plots
% run_sim_vars_bemhd_mult17hd % old - too correlated
run_sim_vars_bemhd_mult17hd_lag40
run_sim_vars_bemhd_single1hd
run_sim_vars_bemhd_distr2hd

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% SINR
% Calculate SINR for mult source configuration
metric_analysis_sinr_mult17_lag40

%% Power plots at t=t1

% % low res
% NOTE Replace low-res plots with high-res
% power_surface_lowres

% high res
power_surface_highres

% beampattern
% beampattern_report



