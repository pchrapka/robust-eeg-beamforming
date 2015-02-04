function save_power(mismatch)

time = 0;
save_images = true;
% save_images = false;
% brainstorm.bstcust_plot_close

%% ==== mult_cort_src_17 ====

snr = '0';
signal_types = {...
    'signal',...
    'interference',...
    'noise',...
    'all',...
    };

cfg_data.sim_name = 'sim_data_bem_1_100t';
% cfg_data.source_name = 'single_cort_src_1';
% cfg_data.source_config = 'src_param_single_cortical_source_1';
cfg_data.source_name = 'mult_cort_src_17';
cfg_data.source_config = 'src_param_mult_cortical_source_17';
cfg_data.snr = snr;
cfg_data.iteration = 1;

for i=1:length(signal_types)
    % Select the signal component
    signal_type = signal_types{i};
    
    % Get the study
    cfg_study = [];
    cfg_study.subject_name = 'Subject01';
    if mismatch
        cfg_study.condition_name = [cfg_data.sim_name '_' cfg_data.source_name '_3sphere'...
            '_power_' signal_type];
    else
        cfg_study.condition_name = [cfg_data.sim_name '_' cfg_data.source_name...
            '_power_' signal_type];
    end
    % Get the study idx
    study_idx = brainstorm.bstcust_study_id(cfg_study);
    % Plot and save the data
    brainstorm.bstcust_plot(study_idx, snr, time, save_images);
    
end

end