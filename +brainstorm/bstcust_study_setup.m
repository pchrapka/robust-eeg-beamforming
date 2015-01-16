function [study_idx] = bstcust_study_setup(cfg)
%BSTCUST_STUDY_SETUP sets up a new study
%   BSTCUST_STUDY_SETUP(CFG) sets a new study based on the params in CFG
%   and returns the study index
%
%   cfg.subject_name    name of the subject
%   cfg.condition_name  name of the condition to create, 
%                       skipped if it exists

% Start Brainstorm
brainstorm.bstcust_start();

% Display condition name
fprintf('Setting up study: %s \n',cfg.condition_name);

% Get the subject
subject = bst_get('Subject', cfg.subject_name, 1);

% Get the current conditions for our subject
studies = bst_get('ConditionsForSubject', subject.FileName);

% Check if the current condition already exists
study_exists = find(file_compare(studies, cfg.condition_name), 1);
if isempty(study_exists)
    disp('Adding condition');
    % Add a new condition
    db_add_condition(cfg.subject_name, cfg.condition_name);
else
    disp('Condition exists');
end

% Get the study id
condition_file = fullfile(...
    cfg.subject_name,cfg.condition_name,'brainstormstudy.mat');
[~, study_idx] = bst_get('Study', condition_file);
end