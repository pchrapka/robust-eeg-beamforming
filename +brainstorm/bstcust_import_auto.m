 function cfg = bstcust_import_auto(cfg)
%BSTCUST_IMPORT_AUTO Import data from beamformer analysis to Brainstorm
%   BSTCUST_IMPORT_AUTO(CFG)
%
%   cfg is a struct with the following fields
%       sim_vars_name   name of the sim_vars config
%       sim_name        name of simulation data config
%       source_name     name of the source config
%       snr             (string) specific snr to import
%       mismatch        (boolean) specify whether scenario is a mismatch,
%                       this adds the appropriate suffixes
%       source_file_tags
%           cell array of tags specifying which source localization results
%           to import
%
%   Output
%   returns cfg with the study_idx field

% Start Brainstorm
brainstorm.bstcust_start();

sim_vars_name = cfg.sim_vars_name;

%% === CHECK FOR MISMATCH SCENARIO ===

% Mismatch data
mismatch = cfg.mismatch;

if mismatch
    % NOTE the condition name is built from the mismatch tag so only add one
    % mismatch at a time
%     mismatch_tags = {'perturb_1'};
%     mismatch_tags = {'perturb_2'};
    mismatch_tags = {'3sphere'};
end

%% ==== SETUP STUDY ====
% Config for the data file
cfg_data = [];
cfg_data.sim_name = cfg.sim_name;
cfg_data.source_name = cfg.source_name;
cfg_data.snr = cfg.snr;
cfg_data.iteration = '1';

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

cfg_study = [];
cfg_study.subject_name = subject_name;
cfg_study.condition_name = condition_name;
cfg.study_idx = brainstorm.bstcust_study_setup(cfg_study);

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
cfg_db = [];
cfg_db.data_file = db.get_full_file_name(cfg_data);
cfg_db.data_file_tag = ['snr_' cfg_data.snr '_' cfg_data.iteration];
cfg_db.eeg = eeg;
cfg_db.study_idx = cfg.study_idx;

% FIXME Check if files already exist, build in option to replace them as
% well.
cfg_db = brainstorm.prep_import_eeg_auto(cfg_db);

%% ==== IMPORT SOURCE RESULTS TO BRAINSTORM ====

cfg_db.source = source;
% Get beamformer analyses to import
cfg_db.tags = cfg.source_file_tags;
% Add the mismatch tag to all the source file tags
if mismatch
    n_tags = length(cfg_db.tags);
    n_mismatch_tags = length(mismatch_tags);
    tmp_tags = {};
    for i=1:n_tags
        for j=1:n_mismatch_tags
            tmp_tags = [tmp_tags [cfg_db.tags{i} '_' mismatch_tags{j}]];
        end
    end
    cfg_db.tags = tmp_tags;
end

cfg_db = brainstorm.prep_import_source_auto(cfg_db);

disp(['Current study: ' num2str(cfg.study_idx)]);

end