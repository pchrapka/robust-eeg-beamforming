%% run_all_bemhd

%% Open the parallel pipeline
% set up parallel execution
lumberjack.parfor_setup();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This will take a while
run_sim_vars_bemhd_paper_mult17hd
