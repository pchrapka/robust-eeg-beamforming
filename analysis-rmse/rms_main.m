%% rms_main

%% Single iteration
rms_analysis_iter1_single_paper_all
rms_analysis_iter1_distr_paper_all
rms_analysis_iter1_mult_paper_all

% rms_analysis_iter1_summary

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Multiple iterations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This section is run on blade where the raw data files are located to
% avoid network transfer when we don't care about the individual data files
% rms_analysis_iters_single_paper_all
% rms_analysis_iters_distr_paper_all
% rms_analysis_iters_mult_paper_all
% rms_analysis_iters_mult_2_paper % TODO

% The summary can be run on your local machine after downloading the rmse
% results for all the trials
% rms_analysis_iters_summary