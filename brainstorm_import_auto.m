%% brainstorm_import
% Import data from beamformer analysis to Brainstorm

%%%%%%%%%%%%%
% README
% The sequence of steps is important
%   1. Copy/create a new condition
%   2. Rename it based on the outputs of the first cell
%   2. Export the EEG data from Brainstorm into a variable named 'eeg'
%   3. Run the second cell to get the an updated 'eeg' variable
%   4. Import 'eeg' as the new EEG data
%   5. Compute source in Brainstorm using the MNE inverse method, with Full
%   and unconstrained options
%   6. Export the result as 'source'
%   7. Run the third cell to create the source analysis variables
%   8. Import the results

%% ==== SETUP STUDY ====
% Get the data file
cfg_data = [];
cfg_data.sim_name = 'sim_data_2';
cfg_data.source_name = 'single_cort_src_1';
cfg_data.snr = '-40';
cfg_data.iteration = '1';

subject_name = 'Subject01';
condition_name = [cfg_data.sim_name '_' cfg_data.source_name];

fprintf('Condition name: %s \n',condition_name);

% Get the subject
subject = bst_get('Subject', subject_name, 1);
% Get the current conditions for our subject
studies = bst_get('ConditionsForSubject', subject.FileName);
% Check if the current condition already exists
study_exists = find(file_compare(studies, condition_name), 1);
if isempty(study_exists)
    disp('Adding condition');
    % Add a new condition
    db_add_condition(subject_name, condition_name);
end
% Get the study id
[~, study_idx] = bst_get('Study',...
    fullfile(subject_name,condition_name,'brainstormstudy.mat'));

%% ==== GET TEMPLATE DATA STRUCT FROM BRAINSTORM ====
% Get a template study
template_study = bst_get('Study',...
    fullfile(subject_name,'template_data','brainstormstudy.mat'));
protocol_info = bst_get('ProtocolInfo');

% Get the eeg data
template_eeg_file = fullfile(protocol_info.STUDIES,...
    template_study.Data.FileName);
eeg = load(template_eeg_file);

% Get the source results data
template_source_file = fullfile(protocol_info.STUDIES,...
    template_study.Result.FileName);
source = load(template_source_file);

%% ==== IMPORT EEG DATA TO BRAINSTORM ====
cfg = [];
cfg.data_file = db.get_full_file_name(cfg_data);
cfg.data_file_tag = ['snr_' cfg_data.snr '_' cfg_data.iteration];
cfg.eeg = eeg;
cfg.study_idx = study_idx;

% FIXME Check if files already exist, build in option to replace them as
% well.
cfg = brainstorm.prep_import_eeg_auto(cfg);

%% ==== IMPORT SOURCE RESULTS TO BRAINSTORM ====

cfg.source = source;
% Beamformer analyses to import
cfg.tags = {'lcmv',...
    'lcmv_eig_1',...
    'lcmv_eig_2',...
    'lcmv_eig_3',...
    'lcmv_reg_eig',...
    'rmv_epsilon_50',...
    'rmv_epsilon_100',...
    ...'rmv_epsilon_150',...
    'rmv_epsilon_200',...
    ...'rmv_epsilon_250',...
    'rmv_epsilon_300',...
    ...'rmv_epsilon_350',...
    'rmv_epsilon_400',...
    'rmv_eig_1_epsilon_50',...
    'rmv_eig_1_epsilon_100',...
    ...'rmv_eig_1_epsilon_150',...
    'rmv_eig_1_epsilon_200',...
    ...'rmv_eig_1_epsilon_250',...
    'rmv_eig_1_epsilon_300',...
    ...'rmv_eig_1_epsilon_350',...
    'rmv_eig_1_epsilon_400'...
    };

cfg = brainstorm.prep_import_source_auto(cfg);
