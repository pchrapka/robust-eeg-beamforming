function cfg = prep_import_eeg_auto(cfg)
%PREP_IMPORT_EEG preps EEG data for import to Brainstorm
%   PREP_IMPORT_EEG(CFG) preps a data file for import as well as any analyses
%   on that data. 
%
%   cfg
%       data_file   full file name of the data file to import
%       data_file_tag   string to represent the data file
%       eeg     exported EEG data from Brainstorm

if ~isfield(cfg,'eeg')
    error('brainstorm:prep_import',...
        'need to include exported EEG data from Brainstorm');
end

% Replace slashes just in case
data_file = strrep(cfg.data_file, '/', filesep);
% Load the data
data_in = load(data_file);    % loads variable data
eeg_data = data_in.data.avg_trials;
clear data_in;

% Load our data into the brainstorm eeg struct
cfg.eeg.F(1:256,:) = eeg_data;
cfg.eeg.Comment = cfg.data_file_tag;

% Get the study
study = bst_get('Study',cfg.study_idx);
% Get the output directory
output_dir = bst_fileparts(file_fullpath(study.FileName));
% Output filename
strType = ['_' cfg.eeg.Comment];
result_file = bst_process('GetNewFilename', output_dir, ['data', strType]);
% Ensure relative/full paths
result_file = file_short(result_file);
protocol_info = bst_get('ProtocolInfo');
result_file_full = fullfile(protocol_info.STUDIES, result_file);

% Save on disk
eeg = cfg.eeg;
save(result_file_full, '-struct', 'eeg');
% Register in database
db_add_data(cfg.study_idx, result_file_full, eeg);

% Save the eeg file name
cfg.eeg_result_file = result_file;

% is_reload = true;
% OutputFile = db_add(cfg.study_idx, eeg, is_reload);
% NewFiles = import_data(DataFiles, FileFormat, iStudyInit, iSubjectInit,
% ImportOptions)

end