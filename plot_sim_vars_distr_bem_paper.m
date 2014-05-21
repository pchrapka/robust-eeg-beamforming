%% plot_sim_vars_distr_bem_paper

%% Start Brainstorm
brainstorm.bstcust_start();

%%
% WARNING!!
% Manually delete the existing study

%% Common Parameters
snr = '0';
mismatch = true;
import = true;

%% Setup the config for distr_bem_paper
cfg = [];
cfg.sim_vars_name = 'sim_vars_distr_src_paper_';
cfg.sim_name = 'sim_data_bem_1_100t';
cfg.source_name = 'distr_cort_src_2';
cfg.snr = snr;
cfg.mismatch = mismatch;
if mismatch
    cfg.source_file_tags = {...
        ...'rmv_epsilon_50',...
        ...'rmv_epsilon_100',...
        'rmv_epsilon_150',...
        ...'rmv_epsilon_200',...
        'rmv_aniso',...
        ...'rmv_eig_post_0_epsilon_50',...
        ...'rmv_eig_post_0_epsilon_100',...
        ...'rmv_eig_post_0_epsilon_150',...
        ...'rmv_eig_post_0_epsilon_200',...
        ...'rmv_aniso_eig_post_0',...
        'lcmv',...
        'lcmv_eig_0',...
        'lcmv_reg_eig'};
else
    cfg.source_file_tags = {...
        'rmv_epsilon_20',...
        ...'rmv_epsilon_50',...
        ...'rmv_eig_post_0_epsilon_20',...
        ...'rmv_eig_post_0_epsilon_50',...
        'lcmv',...
        'lcmv_eig_0',...
        'lcmv_reg_eig'};
end

%% Import the results for distr_bem_paper
if import
    cfg = brainstorm.bstcust_import_auto(cfg);
else
    % TODO Refactor the following section into something like
    % bstcust_create_condition_name, and then add a default option for the
    % subject name
    subject_name = 'Subject01';
    % Set up the condition name
    if mismatch
        condition_name = [...
            cfg.sim_name '_' cfg.source_name '_3sphere'];
    else
        condition_name = [...
            cfg.sim_name '_' cfg.source_name];
    end
    
    cfg_study = [];
    cfg_study.subject_name = subject_name;
    cfg_study.condition_name = condition_name;
    cfg.study_idx = brainstorm.bstcust_study_id(cfg_study);
end

%% Plot the results
brainstorm.bstcust_plot(cfg.study_idx, cfg.snr);

%% Close all plots
% brainstorm.bstcust_plot_close();