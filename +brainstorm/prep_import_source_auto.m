function cfg = prep_import_source_auto(cfg)
%PREP_IMPORT_SOURCE preps data for import to Brainstorm
%   PREP_IMPORT_SOURCE(CFG) preps a data file for import as well as any
%   analyses on that data. 
%
%   cfg
%       data_file   full file name of the data file to import
%       data_file_tag   string to represent the data file
%       source  exported source analysis data from Brainstorm
%       tags    (cell array) names of beamformer analyses to import

if ~isfield(cfg,'eeg')
    error('brainstorm:prep_import',...
        'need to include exported EEG data from Brainstorm');
end

if ~isfield(cfg,'source')
    error('brainstorm:prep_import',...
        'need to include exported source model from Brainstorm');
end


% Replace slashes just in case
data_file = strrep(cfg.data_file, '/', filesep);

% Get the study
study = bst_get('Study', cfg.study_idx);
% Get the output directory
output_dir = bst_fileparts(file_fullpath(study.FileName));

% Prep analyses to import to Brainstorm
% NOTE Analyses are identified by a tag that is appended to the original data
% file name
n_tags = length(cfg.tags);
for i=1:n_tags
    
    % Set up cfg to find the beamformer output data
    tag = cfg.tags{i};
    fprintf('Working on: %s\n',tag);
    
    tmpcfg = [];
    % Assign the beamformer output data file name
    tmpcfg.beamformer_data_file = db.save_setup(...
        'file_name',data_file,'tag',tag);
    % Assign the exported source analysis results from Brainstorm
    tmpcfg.source = cfg.source;
    % norm(source.ImageGridAmp)
    
    try
        % Prep the data
        tmpcfg = brainstorm.prep_source_data(tmpcfg);
    catch e
        fprintf('Couldn''t find %s\n',tag);
        continue;
    end
    if isfield(tmpcfg.source,'Whitener')
        tmpcfg.source = rmfield(tmpcfg.source,'Whitener');
    end
    % Set the beamformer type
    tmpcfg.source.Function = cfg.tags{i};
    % Set the comment to reflect the beamformer type
    tmpcfg.source.Comment = [upper(cfg.tags{i})...
        ': EEG(Full,Unconstr)'];
    tmpcfg.source.nComponents = 3; % Make sure it's unconstrained
    % norm(source.ImageGridAmp)
    
    fprintf('Prepped %s\n',tmpcfg.source.Comment);
    
    % Associate the source results with the data file
    tmpcfg.source.DataFile = cfg.eeg_result_file;
    
    % Output filename
    strType = ['_' cfg.tags{i}];
    result_file = bst_process('GetNewFilename', output_dir, ['results', strType]);
    % Ensure relative/full paths
    result_file = file_short(result_file);
    protocol_info = bst_get('ProtocolInfo');
    result_file_full = fullfile(protocol_info.STUDIES, result_file);
    
    % Save on disk
    source = tmpcfg.source;
    save(result_file_full, '-struct', 'source');
    % Register in database
    db_add_data(cfg.study_idx, result_file_full, source);
end

end