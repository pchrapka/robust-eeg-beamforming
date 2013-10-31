function prep_import(cfg)
%PREP_IMPORT preps data for import to Brainstorm
%   PREP_IMPORT(CFG) preps a data file for import as well as any analyses
%   on that data. 
%
%   cfg
%       data_file   full file name of the data file to import
%       eeg     exported EEG data from Brainstorm
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
% Load the data
data_in = load(data_file);    % loads variable data
eeg_data = data_in.data.avg_trials;
clear data_in;

% Load our data into the brainstorm eeg struct
cfg.eeg.F(1:256,:) = eeg_data;
assignin('caller', 'eeg', cfg.eeg);

% Prep analyses to import to Brainstorm
% NOTE Analyses are identified by a tag that is appended to the original data
% file name
n_tags = length(cfg.tags);
var_new{n_tags} = ''; % allocate memory
for i=1:n_tags
    
    % Set up cfg to find the beamformer output data
    tmpcfg2 = [];
    tmpcfg2.file_name = data_file;
    tmpcfg2.tag = cfg.tags{i};
    
    tmpcfg = [];
    % Assign the beamformer output data file name
    tmpcfg.beamformer_data_file = db.save_setup(tmpcfg2);
    % Assign the exported source analysis results from Brainstorm
    tmpcfg.source = cfg.source;
    % norm(source.ImageGridAmp)
    
    % Prep the data
    tmpcfg = brainstorm.prep_source_data(tmpcfg);
    % Set the beamformer type
    tmpcfg.source.Function = cfg.tags{i};
    % Set the comment to reflect the beamformer type
    tmpcfg.source.Comment = [upper(cfg.tags{i})...
        ': EEG(Full,Unconstr)'];
    % norm(source.ImageGridAmp)
    
    % Assign the source analysis to a variable in the caller workspace
    % Var is created using the tag
    var_new{i} = ['source_' cfg.tags{i}];
    assignin('caller', var_new{i}, tmpcfg.source);
    disp(['Prepped ' tmpcfg.source.Comment]);
end

% Print out instructions to the user
fprintf('\nImport these vars to Brainstorm:\n');
for i=1:n_tags
    fprintf('\t%s\n',var_new{i});
end

end