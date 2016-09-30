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

sim_file = 'sim_data_bem_1_100t';
% sim_file = 'sim_data_bem_1_100t_5000s';
source_file = 'src_param_mult_cortical_source_17_lag40';
source_name = 'mult_cort_src_17_lag40';

run_sim_vars_bem_mult_paper_locs2(...
    sim_file,source_file,source_name,'matched','both');
% Compute sinr vs snr
plot_sinr_mult_config_paper(...
    sim_file,source_name,'matched','both');

% HD for beampatterns and power plots
% -----------------------------------
% Running time: at least 3 time longer than low res

% run_sim_vars_bemhd_mult17hd % old - too correlated
run_sim_vars_bemhd_mult17hd_lag40_paper
% run_sim_vars_bemhd_single1hd_paper
% run_sim_vars_bemhd_distr2hd_paper

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Power plots at t=t1

% % low res
% NOTE Replace low-res plots with high-res
% power_surface_lowres

% high res
% power_surface_mult17hd_lag40
% power_surface_highres % REMOVE old

% beampattern
% beampatternhd_report
% beampattern_mult17hd_lag40



