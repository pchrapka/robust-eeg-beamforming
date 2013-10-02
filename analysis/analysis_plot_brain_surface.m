
%% Instructions
% 1. Export data from WMN analysis in Brainstorm
% Not sure if I need to import the EEG data first

cfg.file_in = ['..' filesep 'output' filesep ...
    'out_sim_vars_1_lcmv.mat'];
cfg.iteration = 1;
cfg.snr = -5;
cfg.bst_source = source; % Need to export var from Brainstorm as source
cfg = analysis_param_sweep_prep_brain_surface(cfg);

%% Next Steps
% 1. Import cfg.eeg_data as the EEG data in Brainstorm
% 2. Import cfg.bst_source into the MN variable in Brainstorm