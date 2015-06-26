%% run_all
util.update_aet();
% Initialize the Advanced EEG Toolbox
aet_init

%% Open the parallel pipeline
cfg = [];
cfg.ncores = 10;
aet_parallel_init(cfg);

highres = false;
if highres
    fprintf('Starting high res simultaions\n');
end    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Running time: approx. 30 minutes for one analysis (one snr, matched and
% mismatched scenarios and RMVB included)

run_sim_vars_single_bem_paper
run_sim_vars_distr_bem_paper
run_sim_vars_bem_paper_mult17

% HD for beampatterns and power plots
% TODO scripts for single and distr
if highres
    run_sim_vars_bemhd_paper_mult17hd
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% SINR
% Calculate SINR for mult source configuration
% metric_analysis_sinr_mult_paper

%% Power plots at t=t1

% % low res
% power_surface_lowres

% high res
% TODO simulate data for single and distr
% TODO FIRST do power plots for high res mult data
% single
% distr
if highres
    power_surface_report
end

%% Close the parallel pipeline
aet_parallel_close([]);


