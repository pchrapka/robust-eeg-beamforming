function study_idx = bstcust_study_id(cfg)
%   Returns the study idx accroding to the spec provided by cfg
%
%   cfg.subject_name    name of the subject
%   cfg.condition_name  name of the condition to find, 
%                       skipped if it exists
%   Example
%   cfg.subject_name = 'Subject01';
%   cfg.condition_name = 'my_condition'

% Start Brainstorm
brainstorm.bstcust_start();

% Get the subject
subject = bst_get('Subject', cfg.subject_name, 1);
% Get the current conditions for our subject
studies = bst_get('ConditionsForSubject', subject.FileName);
% Check if the current condition already exists
study_exists = find(file_compare(studies, cfg.condition_name), 1);
if isempty(study_exists)
    disp('Study does not exist');    
else
    % Get the study id
    condition_file = fullfile(...
        cfg.subject_name,cfg.condition_name,'brainstormstudy.mat');
    [~, study_idx] = bst_get('Study', condition_file);
    
    disp(['Current study: ' num2str(study_idx)]);
end

end