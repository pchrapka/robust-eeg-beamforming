
time = 0;
save_images = true;
% save_images = false;
% brainstorm.bstcust_plot_close

%% ==== mult_cort_src_17 ====
% Get the data file
% cfg_data = [];
% cfg_data.sim_name = 'sim_data_bem_1_100t';
% cfg_data.source_name = 'mult_cort_src_17';
% cfg_data.snr = '0';
% cfg_data.iteration = 1;
% cfg_data.mismatch = false;

source_name = 'mult_cort_src_17';
snr = '0';
signal_type = 'signal';

% Get the study
cfg_study = [];
cfg_study.subject_name = 'Subject01';
cfg_study.condition_name = [source_name '_power_' signal_type];
% Get the study idx
study_idx = brainstorm.bstcust_study_id(cfg_study);
% Plot and save the data
brainstorm.bstcust_plot(study_idx, snr, time, save_images);