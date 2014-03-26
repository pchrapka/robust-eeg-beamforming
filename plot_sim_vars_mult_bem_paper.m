%% plot_sim_vars_mult_bem_paper

%% Start Brainstorm
brainstorm.bstcust_start();

%%
% WARNING!!
% Manually delete the existing study

%% Common Parameters
snr = '0';
mismatch = true;

%% Import the results for mult_bem_paper
cfg = [];
cfg.sim_vars_name = 'sim_vars_mult_src_paper_';
cfg.sim_name = 'sim_data_bem_1_100t';
cfg.source_name = 'mult_cort_src_10';
cfg.snr = snr;
cfg.mismatch = false;
cfg = brainstorm.bstcust_import_auto(cfg);

%% Plot the results
brainstorm.bstcust_plot(cfg.study_idx, cfg.snr);

%% Close all plots
% brainstorm.bstcust_plot_close();