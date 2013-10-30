
%% Update AET
cd('..')
update_aet
cd('analysis')
aet_init

%% Instructions
% 1. Export data from WMN analysis in Brainstorm
% Not sure if I need to import the EEG data first

%% Select data
% cfg.function = 'rmv';
% cfg.function = 'lcmv_eig';
cfg.function = 'lcmv_reg';
cfg.file_in = ['..' filesep 'output' filesep ...
    'out_sim_vars_3_' cfg.function '.mat'];
cfg.iteration = 1;
cfg.snr = -5;
epsilon = 200;%80; %200
cfg.epsilon = ones(3,1)*sqrt(epsilon^2/3);
cfg = analysis_param_sweep_select_data(cfg);
disp('Data selected');

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

%% 
% 1. Export eeg data as eeg
eeg.F(1:256,:) = eeg_data;
% 2. Import eeg again


%% Prep data
% Before running this cell!!
% 1. Export the source results from Brainstorm as source

cfg.bst_source = source; 
norm(source.ImageGridAmp)
cfg = analysis_param_sweep_prep_brain_surface(cfg);
source = cfg.bst_source;
source.Function = cfg.function;
if isequal(cfg.function,'rmv')
    source.Comment = [upper(cfg.function)...
        ': EEG(Full,Unconstr)_epsilon_' num2str(epsilon)];
else
    source.Comment = [upper(cfg.function)...
        ': EEG(Full,Unconstr)'];
end
norm(source.ImageGridAmp)
disp('Data prepped for import');
disp(source.Comment);

% After
% 2. Import source into the source results in Brainstorm

%% Next Steps
% 1. Import cfg.eeg_data as the EEG data in Brainstorm
% 2. Import cfg.bst_source into the MN variable in Brainstorm

% figure;
% for j=1:3
%     for i=1:size(cfg.beam_data,2)
%         comp(i,:) = squeeze(cfg.beam_data(j,i,:));
%     end
%     subplot(3,1,j);
%     surf(comp);
%     view(0, 0);
% end