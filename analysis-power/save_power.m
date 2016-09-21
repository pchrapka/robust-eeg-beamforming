function save_power(mismatch)

time = 0;
save_images = true;
% save_images = false;
% brainstorm.bstcust_plot_close

%% ==== mult_cort_src_17 ====

snr = 0;
signal_types = {...
    'signal',...
    'interference',...
    'noise',...
    'all',...
    };

% source_name = 'single_cort_src_1';
source_name = 'mult_cort_src_17';

data_set = SimDataSetEEG(...
    'sim_data_bem_1_100t',...
    source_name,...
    snr,...
    'iter',1);

for i=1:length(signal_types)
    % Select the signal component
    signal_type = signal_types{i};
    
    % Get the study
    cfg_study = [];
    cfg_study.subject_name = 'Subject01';
    if mismatch
        cfg_study.condition_name = [data_set.sim '_' data_set.source '_3sphere'...
            '_power_' signal_type];
    else
        cfg_study.condition_name = [data_set.sim '_' data_set.source...
            '_power_' signal_type];
    end
    % Get the study idx
    study_idx = brainstorm.bstcust_study_id(cfg_study);
    % Plot and save the data
    brainstorm.bstcust_plot(study_idx, snr, time, save_images);
    
end

end