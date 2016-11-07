
time = 0;
% save_images = true;
save_images = false;
% brainstorm.bstcust_plot_close

%% ==== mult_cort_src_17 ====

sim_name = 'sim_data_bem_1_100t_1000s';
source_name = 'mult_cort_src_17';
snr = '0';
% mismatch = true;
mismatch = false;
signal_type = 'signal';
% signal_type = 'interference';
% signal_type = 'noise';

% Get the study
cfg_study = [];
cfg_study.subject_name = 'Subject01';
if mismatch
    cfg_study.condition_name = [sim_name '_' source_name '_3sphere'...
        '_power_' signal_type];
else
    cfg_study.condition_name = [sim_name '_' source_name...
        '_power_' signal_type];
end
% Get the study idx
study_idx = brainstorm.bstcust_study_id(cfg_study);
% Plot and save the data
brainstorm.bstcust_plot(study_idx, snr, time, save_images);

% Close plots
% brainstorm.bstcust_plot_close
