function bstcust_plot_surface(cfg)
%BSTCUST_PLOT_SURFACE plots a static surface in brainstorm
%   cfg.import  
%       (boolean), if true, creates and imports to Brainstorm, otherwise
%       just plots the errors
%   cfg.condition_name
%       string with condition name
%   cfg.eeg_data_file
%       file name of eeg data set
%   cfg.data
%       data to be plotted on surface, [3 locs samples]
%   cfg.data_tag
%       tag describing the data

%% ==== NO IMPORT, PLOT THE DATA ====
cfg_study = [];
cfg_study.subject_name = 'Subject01';
cfg_study.condition_name = cfg.condition_name;
if ~cfg.import
    study_idx = brainstorm.bstcust_study_id(cfg_study);
    brainstorm.bstcust_plot(study_idx, '0');    
    return
end

tag = cfg.condition_name;
out_dir = fullfile('output', ['bst_' strrep(tag, ' ', '_')]);

% Start brainstorm
brainstorm.bstcust_start();

%% ==== GET TEMPLATE DATA STRUCT FROM BRAINSTORM ====
template_study = bst_get('Study',...
    fullfile(cfg_study.subject_name,'template_data','brainstormstudy.mat'));
protocol_info = bst_get('ProtocolInfo');

% Get the eeg data
template_eeg_file = fullfile(protocol_info.STUDIES,...
    template_study.Data.FileName);
eeg = load(template_eeg_file);

% Get the source results data
template_source_file = fullfile(protocol_info.STUDIES,...
    template_study.Result.FileName);
source_template = load(template_source_file);

% Check if the study exists
study_idx = brainstorm.bstcust_study_id(cfg_study);
if study_idx == 0
    %% ==== CREATE NEW STUDY IN BRAINSTORM ====
    study_idx = brainstorm.bstcust_study_setup(cfg_study);
    
    
    cfg_eeg = [];
    cfg_eeg.data_file_in = cfg.eeg_data_file;
    cfg_eeg.data_file_out = fullfile(out_dir, 'eeg.mat');
    % if ~exist(cfg_eeg.data_file_out,'file')
    %% ==== COPY EEG DATA ====
    [pathstr,~,~,~] = util.fileparts(cfg_eeg.data_file_out);
    if ~exist(pathstr,'dir')
        mkdir(pathstr);
    end
    copyfile(cfg_eeg.data_file_in, cfg_eeg.data_file_out);
    
    % FIXME This can be more sophisticated but I'm just curious right now
    
    %% ==== IMPORT EEG DATA TO BRAINSTORM ====
    
    cfg_db = [];
    cfg_db.data_file = fullfile(out_dir, 'eeg.mat');
    cfg_db.data_file_tag = 'snr_0';
    cfg_db.eeg = eeg;
    cfg_db.study_idx = study_idx;
    
    % FIXME Check if files already exist, build in option to replace them as
    % well.
    cfg_db = brainstorm.prep_import_eeg_auto(cfg_db);
else
    % Get the study
    study = bst_get('Study', study_idx);
    
    cfg_db = [];
    cfg_db.data_file = fullfile(out_dir, 'eeg.mat');
    cfg_db.data_file_tag = 'snr_0';
    cfg_db.eeg = eeg;
    cfg_db.eeg_result_file = study.Data(1).FileName;
    cfg_db.study_idx = study_idx;
end

%% ==== SAVE DATA TO FILE ====
% Fake a beamformer output file to reuse the bstcust import functions
% FIXME Make the bstcust import functions more generic
n_locs = size(source_template.ImageGridAmp,1)/3;
if ~isequal(size(cfg.data,1), 3)
    disp(size(cfg.data));
    error(['rmvb:' mfilename],...
        'cfg.data is missing components');
end
if ~isequal(size(cfg.data,2), n_locs)
    disp(size(cfg.data));
    error(['rmvb:' mfilename],...
        'cfg.data is missing locations');
end
if ~isequal(size(cfg.data,3), length(eeg.Time)) 
    if isequal(size(cfg.data,3), 1)
        % Copy data over time samples
        cfg.data = repmat(cfg.data, 1,1, length(eeg.Time));
    else
        disp(size(cfg.data));
        error(['rmvb:' mfilename],...
            'cfg.data is missing samples');
    end
end
source = [];
source.beamformer_output = cfg.data;
% source.beamformer_output = zeros(3, n_locs, length(eeg.Time));
% source.beamformer_output(1,:,:) = repmat(beampattern_data',[1 1 length(eeg.Time)]);
save_file = fullfile(out_dir,...
    ['eeg_' cfg.data_tag '.mat']);
save(save_file,'source');

%% ==== IMPORT SOURCE RESULTS TO BRAINSTORM ====

cfg_db.source = source_template;
cfg_db.tags = {cfg.data_tag};
cfg_db = brainstorm.prep_import_source_auto(cfg_db);

%% ==== PLOT THE BEAMPATTERN ====
brainstorm.bstcust_plot(study_idx, '0');
    
end