%% plot_sim_vars_mult_2_bem_paper

%% Start Brainstorm
brainstorm.bstcust_start();

%%
% WARNING!!
% Manually delete the existing study

%% Common Parameters
snr = 0;
mismatch = true;
% import = true;
import = false;

%% Setup the config for mult_bem_paper
cfg = [];
cfg.sim_vars_name = 'sim_vars_mult_src_paper_';
cfg.data_set = SimDataSetEEG(...
    'sim_data_bem_1_100t_1000s',...
    'mult_cort_src_17',...
	snr,...
    'iter',1);

cfg.mismatch = mismatch;
if mismatch
    cfg.source_file_tags = {...
        ...'rmv_epsilon_50',...
        ...'rmv_epsilon_100',...
        'rmv_epsilon_150',...
        'rmv_epsilon_200',...
        'rmv_aniso',...        
        ...'rmv_eig_post_1_epsilon_50',...
        ...'rmv_eig_post_1_epsilon_100',...
        ...'rmv_eig_post_1_epsilon_150',...
        ...'rmv_eig_post_1_epsilon_200',...
        ...'rmv_aniso_eig_post_1',...
        'lcmv',...
        'lcmv_eig_1',...
        'lcmv_reg_eig'};
else
    cfg.source_file_tags = {...
        'rmv_epsilon_20',...
        ...'rmv_epsilon_50',...
        ...'rmv_eig_post_1_epsilon_20',...
        ...'rmv_eig_post_1_epsilon_50',...
        'lcmv',...
        'lcmv_eig_1',...
        'lcmv_reg_eig'};
end

%% Import the results for mult_bem_paper
if import
    cfg = brainstorm.bstcust_import_auto(cfg);
else
    cfg.study_idx = brainstorm.bstcust_study_id_simdata(cfg);
end

%% Plot the results
brainstorm.bstcust_plot(cfg.study_idx, cfg.snr);

%% Close all plots
% brainstorm.bstcust_plot_close();
