%% experiment_cov_trialtime

lumberjack.parfor_setup();
snr_step = 10;

%% scenario 1
%   Description
%   -----------
%   Scenario where the covariance is computed across trials and samples and
%   not from the ensemble average. The SNR is adjusted on the average

% sim_file = 'sim_data_bem_1_1000t_noavg';
% source_file = 'src_param_s1_randerp_s2_cnoise_neeg';
% source_name = 's1_randerp_s2_cnoise_neeg';
% 
% run_sim_vars_bem_mult_paper_locs2(...
%     sim_file, source_file, source_name,...
%     'snrs',-25:snr_step:15,...
%     'cov_type','trial',...
%     'cov_samples',[115:125],...
%     'hmconfigs',{'matched','mismatched'});
% 
% % plots
% plot_sinr_mult_config_paper(...
%     sim_file, source_name,...
%     'snrs',-25:snr_step:15,...
%     'onaverage',false,...
%     'trial_idx',1:100,...
%     'PlotGroups',{'matched-paper','mismatched-paper'});
% 
% % plot_sinr_mult_config_paper(...
% %     sim_file, source_name,...
% %     'snrs',-25:snr_step:15,...
% %     'onaverage',true,...
% %     'PlotGroups',{'matched-paper','mismatched-paper'});

%% scenario 2
%   Description
%   -----------
%   Scenario where the covariance is computed across trials and samples and
%   not from the ensemble average. The SNR is adjusted for each trial.
%
%   Issue:
%   The eigenspace MVB performs poorly in scenario 1 regardless of whether
%   we look at the metrics for the average or single trials.
%
%   Hypothesis: 
%   We're operating on a shifted input SNR scale. Since the covariance is
%   computed from single trials, the input SNR as computed in the metrics
%   should be equivalent to the single trial SNR. 
%   In the single trial plots from above, the problem is only half
%   rectified as the original single trial SNRs are really low, where the
%   MVB eig performs poorly.

% sim_file = 'sim_data_bem_1_1000t_200s_keeptrials_snrpertrial';
sim_file = 'sim_data_bem_1_100t_1000s_keeptrials_snrpertrial';
source_file = 'src_param_s1_randerp_s2_cnoise_neeg';
source_name = 's1_randerp_s2_cnoise_neeg';

run_sim_vars_bem_mult_paper_locs2(...
    sim_file, source_file, source_name,...
    'snrs',-25:snr_step:15,...
    'cov_type','trial',...
    ...'cov_samples',[115:125],...
    'cov_samples',[1:1000],...
    ...'hmconfigs',{'matched','mismatched'},...
    'hmconfigs',{'matched'}...
    );

% plot single trial sinr
plot_sinr_mult_config_paper(...
    sim_file, source_name,...
    'snrs',-25:snr_step:15,...
    'onaverage',false,...
    'trial_idx',1:100,...
    'datatag','locs2_covtrial_s1-1000',...
    'PlotGroups',{'matched-paper'});

run_sim_vars_bem_mult_paper_locs2(...
    sim_file, source_file, source_name,...
    'snrs',-25:snr_step:15,...
    'cov_type','trial',...
    'cov_samples',[115:125],...
    ...'hmconfigs',{'matched','mismatched'},...
    'hmconfigs',{'matched'}...
    );

% plot single trial sinr
plot_sinr_mult_config_paper(...
    sim_file, source_name,...
    'snrs',-25:snr_step:15,...
    'onaverage',false,...
    'trial_idx',1:100,...
    'data_idx',115:125,...
    'datatag','locs2_covtrial_s115-125',...
    'PlotGroups',{'matched-paper'}...
    );

%% scenario 3
%   Description
%   -----------
%   Scenario where the covariance is computed across trials and samples and
%   not from the ensemble average. Except we're using the mult17_lag40
%   config.
%
%   Issue:
%   The eigenspace MVB performs poorly in scenario 1 and 2 regardless of
%   whether we look at the metrics for the average or single trials. And
%   the number of samples used to compute to covariance doesn't have much
%   of a difference either.
%
%   Hypothesis: 
%   There's an issue with the second source. Maybe it's because it's
%   continuous or maybe be it's random

% sim_file = 'sim_data_bem_1_1000t_200s_keeptrials_snrpertrial';
sim_file = 'sim_data_bem_1_100t_1000s_keeptrials_snrpertrial';
source_file = 'src_param_mult_cortical_source_17_lag40';
source_name = 'mult_cort_src_17_lag40';
% source_file = 'src_param_mult_cortical_source_17_lag40_smallnoise';
% source_name = 'mult_cort_src_17_lag40_smallnoise';

% spatially uncorrelated
% source_file = 'src_param_mult_cortical_source_18_lag40';
% source_name = 'mult_cort_src_18_lag40';

run_sim_vars_bem_mult_paper_locs2(...
    sim_file, source_file, source_name,...
    'snrs',-25:snr_step:15,...
    'cov_type','trial',...
    'cov_samples',[1:1000],...
    'hmconfigs',{'matched'}...
    );

% plot single trial sinr
plot_sinr_mult_config_paper(...
    sim_file, source_name,...
    'snrs',-25:snr_step:15,...
    'onaverage',false,...
    'trial_idx',1:100,...
    'datatag','locs2_covtrial_s1-1000',...
    'PlotGroups',{'matched-paper'}...
    );

run_sim_vars_bem_mult_paper_locs2(...
    sim_file, source_file, source_name,...
    'snrs',-25:snr_step:15,...
    'cov_type','trial',...
    'cov_samples',[115:165],...
    ...'hmconfigs',{'matched','mismatched'},...
    'hmconfigs',{'matched'}...
    );

% plot single trial sinr
plot_sinr_mult_config_paper(...
    sim_file, source_name,...
    'snrs',-25:snr_step:15,...
    'onaverage',false,...
    'trial_idx',1:100,...
    'data_idx',115:165,...
    'datatag','locs2_covtrial_s115-165',...
    'PlotGroups',{'matched-paper'}...
    );

%% scenario 4
%   Description
%   -----------
%   Same as scenario 3 except we're using sources with randon amplitudes
%
%   Issue:
%
%   Hypothesis: 

% sim_file = 'sim_data_bem_1_1000t_200s_keeptrials_snrpertrial';
sim_file = 'sim_data_bem_1_100t_1000s_keeptrials_snrpertrial';
source_file = 'src_param_mult_cortical_source_17_lag40_randamp';
source_name = 'mult_cort_src_17_lag40_randamp';

% spatially uncorrelated
% source_file = 'src_param_mult_cortical_source_18_lag40_randamp';
% source_name = 'mult_cort_src_18_lag40_randamp';

run_sim_vars_bem_mult_paper_locs2(...
    sim_file, source_file, source_name,...
    'snrs',-25:snr_step:15,...
    'cov_type','trial',...
    ...'cov_samples',[115:125],...
    'cov_samples',[1:1000],...
    ...'hmconfigs',{'matched','mismatched'},...
    'hmconfigs',{'matched'}...
    );

% plot single trial sinr
plot_sinr_mult_config_paper(...
    sim_file, source_name,...
    'snrs',-25:snr_step:15,...
    'onaverage',false,...
    'trial_idx',1:100,...
    'datatag','locs2_covtrial_s1-1000',...
    'PlotGroups',{'matched-paper'}...
    );

run_sim_vars_bem_mult_paper_locs2(...
    sim_file, source_file, source_name,...
    'snrs',-25:snr_step:15,...
    'cov_type','trial',...
    'cov_samples',[115:165],...
    ...'hmconfigs',{'matched','mismatched'},...
    'hmconfigs',{'matched'}...
    );

% plot single trial sinr
plot_sinr_mult_config_paper(...
    sim_file, source_name,...
    'snrs',-25:snr_step:15,...
    'onaverage',false,...
    'trial_idx',1:100,...
    'data_idx',115:165,...
    'datatag','locs2_covtrial_s115-165',...
    'PlotGroups',{'matched-paper'}...
    );