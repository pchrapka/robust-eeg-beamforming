
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
cfg.snr = -5;
cfg.epsilon = ones(3,1)*sqrt(80^2/3);
cfg = analysis_param_sweep_select_data(cfg);

%% Load the EEG data
% NOTE At this point we should have filtered down to a single data set
data_file = ['..' filesep cfg.out(1).data_file];
% Replace slashes just in case
data_file = strrep(data_file, '/', filesep);
load(data_file);    % loads variable data
cfg.eeg_data = data.avg_trials;
clear data;

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

figure;
for j=1:3
    for i=1:size(cfg.beam_data,2)
        comp(i,:) = squeeze(cfg.beam_data(j,i,:));
    end
    subplot(3,1,j);
    surf(comp);
    view(0, 0);
end