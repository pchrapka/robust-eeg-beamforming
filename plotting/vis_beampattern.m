function vis_beampattern(cfg)
%VIS_BEAMPATTERN plots the beampattern of a beamformer
%   cfg.import  (boolean), if true, creates and imports to Brainstorm,
%               otherwise just plots the errors
%   cfg.beamformer_file
%               (string) path to beamformer output data
%   cfg.beamformer_file_2
%               (string) path to another set of beamformer output data,
%               if specified, the function takes the difference between the
%               beampatterns (file 1 - file 2)
%   cfg.voxel_idx
%               index of voxel of interest

%% ==== NO IMPORT, PLOT THE ERRORS ====
cfg_study = [];
cfg_study.subject_name = 'Subject01';
cfg_study.condition_name = 'beampattern';
if ~cfg.import
    study_idx = brainstorm.bstcust_study_id(cfg);
    brainstorm.bstcust_plot(study_idx, '0');    
    return
end

%% ==== COPY EEG DATA ====
tag = 'beampattern';
cfg_eeg = [];
[datapath,~,~] = fileparts(cfg.beamformer_file);
cfg_eeg.data_file_in = fullfile(datapath,'0_1.mat');
cfg_eeg.data_file_out = fullfile('output', tag, 'eeg.mat');
[pathstr,~,~,~] = util.fileparts(cfg_eeg.data_file_out);
if ~exist(pathstr,'dir')
    mkdir(pathstr);
end
copyfile(cfg_eeg.data_file_in, cfg_eeg.data_file_out);

% FIXME This can be more sophisticated but I'm just curious right now

%% ==== CALCULATE BEAMPATTERN ====
cfg.distances = false;
din = load(cfg.beamformer_file);

% laod head model
head_cfg = din.source.head_cfg;
if isfield(head_cfg,'current')
    head_cfg = head_cfg.current;
end
hmfactory = HeadModel();
cfg.head = hmfactory.createHeadModel(head_cfg.type, head_cfg.file);

beampattern_data = beampattern(cfg);
if isfield(cfg,'beamformer_file_2')
    % Take the difference between the beampatterns of both beamformers
    cfg_temp = cfg;
    cfg_temp.beamformer_file = cfg_temp.beamformer_file_2;
    beampattern_data_2 = beampattern(cfg_temp);
    beampattern_data = beampattern_data - beampattern_data_2;
end

%% ==== CREATE NEW STUDY IN BRAINSTORM ====
study_idx = brainstorm.bstcust_study_setup(cfg_study);

%% ==== GET TEMPLATE DATA STRUCT FROM BRAINSTORM ====
% Get a template study
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

%% ==== IMPORT EEG DATA TO BRAINSTORM ====

cfg_db = [];
cfg_db.data_file = fullfile('output', tag, 'eeg.mat');
cfg_db.data_file_tag = 'snr_0';
cfg_db.eeg = eeg;
cfg_db.study_idx = study_idx;

% FIXME Check if files already exist, build in option to replace them as
% well.
cfg_db = brainstorm.prep_import_eeg_auto(cfg_db);

%% ==== SAVE BEAMPATTERN TO FILE ====
% Have to fake a beamformer output file so I can reuse the bstcust import
% functions
% n_locs = size(source_template.ImageGridAmp,1)/3;
n_locs = length(beampattern_data);
source.beamformer_output = zeros(3, n_locs, length(eeg.Time));
source.beamformer_output(1,:,:) = repmat(beampattern_data',[1 1 length(eeg.Time)]);
save_file = fullfile('output', tag,...
    ['eeg_' tag '.mat']);
save(save_file,'source');

%% ==== IMPORT SOURCE RESULTS TO BRAINSTORM ====

cfg_db.source = source_template;
cfg_db.tags = {tag};
% FIXME Issue here
cfg_db = brainstorm.prep_import_source_auto(cfg_db);

%% ==== PLOT THE BEAMPATTERN ====
brainstorm.bstcust_plot(study_idx, '0');
    
end