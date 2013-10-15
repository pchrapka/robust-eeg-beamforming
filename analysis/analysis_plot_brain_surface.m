
%% Update AET
cd('..')
update_aet
cd('analysis')
aet_init
%% Instructions
% 1. Export data from WMN analysis in Brainstorm
% Not sure if I need to import the EEG data first

%% Select data
cfg.file_in = ['..' filesep 'output' filesep ...
    'out_sim_vars_3_lcmv.mat'];
cfg.iteration = 1;
cfg.snr = 10;
cfg.epsilon = ones(3,1)*sqrt(80^2/3);
cfg = analysis_param_sweep_select_data(cfg);

% Save to a temp file
eeg_data = cfg.eeg_data;
save('temp.mat','eeg_data');


%% Prep data
cfg.bst_source = source; % Need to export var from Brainstorm as source
norm(source.ImageGridAmp)
cfg = analysis_param_sweep_prep_brain_surface(cfg);
source = cfg.bst_source;
norm(source.ImageGridAmp)

%% Next Steps
% 1. Import cfg.eeg_data as the EEG data in Brainstorm
% 2. Import cfg.bst_source into the MN variable in Brainstorm