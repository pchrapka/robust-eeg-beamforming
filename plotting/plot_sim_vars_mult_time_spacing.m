%% plot_sim_vars_mult_time_spacing

%% Start Brainstorm
brainstorm.bstcust_start();

%%
% WARNING!!
% if import = true
% Manually delete the existing study

mismatch = true;
import = false;
snr = 0;
sims_to_plot = [9,10,11];
source_file_tags = {...
    'lcmv',...
    'rmv_epsilon_0-01',...
    ...'rmv_epsilon_5',...
    'rmv_aniso'
    };

if ~isempty(find(sims_to_plot == 9,1))
    %% Import the results for mult_cort_src_9
    cfg = [];
    cfg.sim_vars_name = 'sim_vars_mult_src_basic_';
    cfg.data_set = SimDataSetEEG(...
        'sim_data_bem_1_100t_1000s',...
        'mult_cort_src_9',...
        snr,...
        'iter',1);
    cfg.mismatch = mismatch;
    cfg.source_file_tags = source_file_tags;
    if import
        cfg = brainstorm.bstcust_import_auto(cfg);
    else
        cfg.study_idx = brainstorm.bstcust_study_id_simdata(cfg);
    end
    
    %% Plot the results
    brainstorm.bstcust_plot(cfg.study_idx, cfg.snr);
end

if ~isempty(find(sims_to_plot == 10,1))
    %% Import the results for mult_cort_src_10
    cfg = [];
    cfg.sim_vars_name = 'sim_vars_mult_src_basic_';
    cfg.data_set = SimDataSetEEG(...
        'sim_data_bem_1_100t_1000s',...
        'mult_cort_src_10',...
        snr,...
        'iter',1);
    cfg.mismatch = mismatch;
    cfg.source_file_tags = source_file_tags;
    if import
        cfg = brainstorm.bstcust_import_auto(cfg);
    else
        cfg.study_idx = brainstorm.bstcust_study_id_simdata(cfg);
    end
    
    %% Plot the results
    brainstorm.bstcust_plot(cfg.study_idx, cfg.snr);
end

if ~isempty(find(sims_to_plot == 11,1))
    %% Import the results for mult_cort_src_11
    cfg = [];
    cfg.sim_vars_name = 'sim_vars_mult_src_basic_';
    cfg.data_set = SimDataSetEEG(...
        'sim_data_bem_1_100t_1000s',...
        'mult_cort_src_11',...
        snr,...
        'iter',1);
    cfg.mismatch = mismatch;
    cfg.source_file_tags = source_file_tags;
    if import
        cfg = brainstorm.bstcust_import_auto(cfg);
    else
        cfg.study_idx = brainstorm.bstcust_study_id_simdata(cfg);
    end
    
    %% Plot the results
    brainstorm.bstcust_plot(cfg.study_idx, cfg.snr);
end

if ~isempty(find(sims_to_plot == 12,1))
    %% Import the results for mult_cort_src_12
    cfg = [];
    cfg.sim_vars_name = 'sim_vars_mult_src_basic_';
    cfg.data_set = SimDataSetEEG(...
        'sim_data_bem_1_100t_1000s',...
        'mult_cort_src_12',...
        snr,...
        'iter',1);
    cfg.mismatch = mismatch;
    cfg.source_file_tags = source_file_tags;
    if import
        cfg = brainstorm.bstcust_import_auto(cfg);
    else
        cfg.study_idx = brainstorm.bstcust_study_id_simdata(cfg);
    end
    
    %% Plot the results
    brainstorm.bstcust_plot(cfg.study_idx, cfg.snr);
end

if ~isempty(find(sims_to_plot == 13,1))
    %% Import the results for mult_cort_src_13
    cfg = [];
    cfg.sim_vars_name = 'sim_vars_mult_src_basic_';
    cfg.data_set = SimDataSetEEG(...
        'sim_data_bem_1_100t_1000s',...
        'mult_cort_src_13',...
        snr,...
        'iter',1);
    cfg.mismatch = mismatch;
    cfg.source_file_tags = source_file_tags;
    if import
        cfg = brainstorm.bstcust_import_auto(cfg);
    else
        cfg.study_idx = brainstorm.bstcust_study_id_simdata(cfg);
    end
    
    %% Plot the results
    brainstorm.bstcust_plot(cfg.study_idx, cfg.snr);
end

if ~isempty(find(sims_to_plot == 14,1))
    %% Import the results for mult_cort_src_14
    cfg = [];
    cfg.sim_vars_name = 'sim_vars_mult_src_basic_';
    cfg.data_set = SimDataSetEEG(...
        'sim_data_bem_1_100t_1000s',...
        'mult_cort_src_14',...
        snr,...
        'iter',1);
    cfg.mismatch = mismatch;
    cfg.source_file_tags = source_file_tags;
    if import
        cfg = brainstorm.bstcust_import_auto(cfg);
    else
        cfg.study_idx = brainstorm.bstcust_study_id_simdata(cfg);
    end
    
    %% Plot the results
    brainstorm.bstcust_plot(cfg.study_idx, cfg.snr);
end

if ~isempty(find(sims_to_plot == 15,1))
    %% Import the results for mult_cort_src_15
    cfg = [];
    cfg.sim_vars_name = 'sim_vars_mult_src_basic_';
    cfg.data_set = SimDataSetEEG(...
        'sim_data_bem_1_100t_1000s',...
        'mult_cort_src_15',...
        snr,...
        'iter',1);
    cfg.mismatch = mismatch;
    cfg.source_file_tags = source_file_tags;
    if import
        cfg = brainstorm.bstcust_import_auto(cfg);
    else
        cfg.study_idx = brainstorm.bstcust_study_id_simdata(cfg);
    end
    
    %% Plot the results
    brainstorm.bstcust_plot(cfg.study_idx, cfg.snr);
end

%% Close all plots
% brainstorm.bstcust_plot_close();
