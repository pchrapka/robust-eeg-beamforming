
time = 0;
save_images = true;
% save_images = false;
% brainstorm.bstcust_plot_close

%% ==== mult_cort_src_17 ====

source_name = 'mult_cort_src_17';
snr = '0';
signal_types = {...
    'signal',...
    'interference',...
    'noise',...
    };

for i=1:length(signal_types)
    % Select the signal component
    signal_type = signal_types{i};
    
    % Get the study
    cfg_study = [];
    cfg_study.subject_name = 'Subject01';
    cfg_study.condition_name = [source_name '_power_' signal_type];
    % Get the study idx
    study_idx = brainstorm.bstcust_study_id(cfg_study);
    % Plot and save the data
    brainstorm.bstcust_plot(study_idx, snr, time, save_images);
    
end