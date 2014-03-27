%% plot_sim_vars_distr_bem_paper

%% Start Brainstorm
brainstorm.bstcust_start();

%%
% WARNING!!
% Manually delete the existing study

%% Common Parameters
snr = '0';
mismatch = true;

%% Import the results for distr_bem_paper
cfg = [];
cfg.sim_vars_name = 'sim_vars_distr_src_paper_';
cfg.sim_name = 'sim_data_bem_1_100t';
cfg.source_name = 'distr_cort_src_2';
cfg.snr = snr;
cfg.mismatch = mismatch;
cfg = brainstorm.bstcust_import_auto(cfg);

%% Plot the results
brainstorm.bstcust_plot(cfg.study_idx, cfg.snr);

%% Close all plots
% brainstorm.bstcust_plot_close();