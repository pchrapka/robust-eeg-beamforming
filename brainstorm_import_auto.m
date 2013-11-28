%% brainstorm_import_auto
% Import data from beamformer analysis to Brainstorm

% Mismatch data
mismatch = true;

%% ==== SETUP STUDY ====
% Get the data file
cfg_data = [];
cfg_data.sim_name = 'sim_data_bem_1';%'sim_data_2_test_beamformer';
cfg_data.source_name = 'single_cort_src_1';
cfg_data.snr = '0';
cfg_data.iteration = '1';

if mismatch
    % NOTE the condition name is built from the mismatch tag so only add one
    % mismatch at a time
%     mismatch_tags = {'mismatch_1'};
%     mismatch_tags = {'mismatch_2'};
    mismatch_tags = {'3sphere'};
    % Check that only one mismatch is being analyzed at a time
    if length(mismatch_tags) > 1
        error('reb:brainstorm_import_auto',...
            'only one mismatch at a time please');
    end
end

subject_name = 'Subject01';
% Set up the condition name
if mismatch
    condition_name = [cfg_data.sim_name '_'...
        cfg_data.source_name '_' mismatch_tags{1}];
else
    condition_name = [cfg_data.sim_name '_'...
        cfg_data.source_name];
end

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
    'rmv_eig_1_epsilon_5',...
    'rmv_eig_1_epsilon_10',...
    'rmv_eig_1_epsilon_20',...
    'rmv_eig_1_epsilon_30',...
    'rmv_eig_1_epsilon_40'...
    'rmv_eig_1_epsilon_50',...
    'rmv_eig_1_epsilon_100',...
    ...'rmv_eig_1_epsilon_150',...
    'rmv_eig_1_epsilon_200',...
    ...'rmv_eig_1_epsilon_250',...
    'rmv_eig_1_epsilon_300',...
    ...'rmv_eig_1_epsilon_350',...
    'rmv_eig_1_epsilon_400'...
    };
if mismatch
    n_tags = length(cfg.tags);
    n_mismatch_tags = length(mismatch_tags);
    tmp_tags = {};
    for i=1:n_tags
        for j=1:n_mismatch_tags
            tmp_tags = [tmp_tags [cfg.tags{i} '_' mismatch_tags{j}]];
        end
    end
    cfg.tags = tmp_tags;
end

cfg = brainstorm.prep_import_source_auto(cfg);

disp(['Current study: ' num2str(study_idx)]);

%% ==== PLOT CURRENT RESULTS ====

% brainstorm_plot(sutdy_idx);
% brainstorm_plot_close();
