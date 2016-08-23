%% run_all
util.update_aet();
% Initialize the Advanced EEG Toolbox
aet_init

%% Open the parallel pipeline
cfg = [];
cfg.ncores = 10;
aet_parallel_init(cfg);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Running time: approx. 30 minutes for one analysis (one snr, matched and
% mismatched scenarios and RMVB included)

% Low res simulations for Output SINR vs Input SNR
run_sim_vars_single_bem_paper
run_sim_vars_distr_bem_paper
run_sim_vars_bem_paper_mult17

% HD for beampatterns and power plots
run_sim_vars_bemhd_paper_mult17hd
run_sim_vars_bemhd_paper_single1hd
run_sim_vars_bemhd_paper_distr2hd

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% SINR
% Calculate SINR for mult source configuration
% metric_analysis_sinr_mult_paper

%% Power plots at t=t1

% % low res
% NOTE Replace low-res plots with high-res
% power_surface_lowres

% high res
power_surface_highres

%% Close the parallel pipeline
aet_parallel_close([]);


