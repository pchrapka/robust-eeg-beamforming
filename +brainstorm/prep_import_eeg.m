function prep_import_eeg(cfg)
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
assignin('caller', 'eeg', cfg.eeg);

% Print out instructions to the user
fprintf('\nImport these vars to Brainstorm:\n');
fprintf('\t%s\n','eeg');

end