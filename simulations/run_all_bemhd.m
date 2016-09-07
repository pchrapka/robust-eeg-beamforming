%% run_all_bemhd

%% Open the parallel pipeline
cfg = [];
cfg.ncores = 10;
aet_parallel_init(cfg);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This will take a while
run_sim_vars_bemhd_paper_mult17hd

%% Close the parallel pipeline
aet_parallel_close([]);