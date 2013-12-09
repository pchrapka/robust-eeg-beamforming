function study_idx = bstcust_study_id(cfg_data)
%   Returns the study idx accroding to the spec provided by cfg_data
%
%   Example:
%
%   cfg_data = [];
%   cfg_data.sim_name = 'sim_data_bem_1_100t';
%   cfg_data.source_name = 'mult_cort_src_6';
%   cfg_data.snr = '0';
%   cfg_data.iteration = '1';
%   cfg_data.mismatch = true;
%   cfg_data.mistmach_tags = {'3sphere'};

%% ==== SETUP STUDY ====
if cfg_data.mismatch
    % NOTE the condition name is built from the mismatch tag so only add one
    % mismatch at a time
    % Check that only one mismatch is being analyzed at a time
    if length(cfg_data.mismatch_tags) > 1
        error('reb:brainstorm_import_auto',...
            'only one mismatch at a time please');
    end
end

subject_name = 'Subject01';
% Set up the condition name
if cfg_data.mismatch
    condition_name = [cfg_data.sim_name '_'...
        cfg_data.source_name '_' cfg_data.mismatch_tags{1}];
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
    disp('Study does not exist');    
else
    % Get the study id
    [~, study_idx] = bst_get('Study',...
        fullfile(subject_name,condition_name,'brainstormstudy.mat'));
    
    disp(['Current study: ' num2str(study_idx)]);
end

end