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
% ------------------------------------------------
% run_sim_vars_bem_single
% run_sim_vars_bem_distr
% run_sim_vars_bem_mult17 % old - too correlated
run_sim_vars_bem_mult17_lag40_locs2_paper

% HD for beampatterns and power plots
% -----------------------------------
% Running time: at least 3 time longer than low res

% run_sim_vars_bemhd_mult17hd % ol  d - too correlated
run_sim_vars_bemhd_mult17hd_lag40_paper
run_sim_vars_bemhd_single1hd_paper
run_sim_vars_bemhd_distr2hd_paper

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
power_surface_mult17hd_lag40
% power_surface_highres % REMOVE old

% beampattern
% beampattern_report



