function vis_beampattern(cfg)
%
%   cfg.import  (boolean), if true, creates and imports to Brainstorm,
%               otherwise just plots the errors
%   cfg.beamformer_file
%               (string) path to beamformer output data

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
cfg_eeg.data_file_in = 'output\sim_data_bem_1_100t\single_cort_src_1\0_1.mat';
cfg_eeg.data_file_out = fullfile('output', tag, 'eeg.mat');
[pathstr,~,~,~] = fileparts(cfg_eeg.data_file_out);
if ~exist(pathstr,'dir')
    mkdir(pathstr);
end
copyfile(cfg_eeg.data_file_in, cfg_eeg.data_file_out);

% FIXME This can be more sophisticated but I'm just curious right now

%% ==== CALCULATE BEAMPATTERN ====

% Load the beamformer output data
data_in = load(cfg.beamformer_file);

n_locs = length(data_in.out.loc);
% Allocate memory
beampattern = zeros(n_locs,1);
% FIXME beampattern needs to be the proper size
for i=1:n_locs
    % Extract the data at each index
    H = data_in.source.leadfield{i};
    W = data_in.source.filter{i};
    loc = data_in.source.loc(i);
    
    % Calculate the frobenius norm of the gain matrix
    beampattern(loc,1) = norm(W'*H, 'fro');
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
source.beamformer_output = zeros(3, n_locs, length(eeg.Time));
source.beamformer_output(1,:,:) = repmat(beampattern',[1 1 length(eeg.Time)]);
save_file = fullfile('output', tag,...
    ['eeg_' tag '_mini.mat']);
save(save_file,'source');

%% ==== IMPORT SOURCE RESULTS TO BRAINSTORM ====

cfg_db.source = source_template;
cfg_db.tags = {tag};
cfg_db = brainstorm.prep_import_source_auto(cfg_db);

%% ==== PLOT THE BEAMPATTERN ====
brainstorm.bstcust_plot(study_idx, '0');
    
end