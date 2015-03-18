function vis_leadfield_error(cfg)
%
%   cfg.import  (boolean), if true, creates and imports to Brainstorm,
%               otherwise just plots the errors
%   cfg.threshold   
%               (default = 1000) shows errors under a certain threshold
%   cfg.projection 
%               (boolean, default = false) toggles projection of
%               leadfield matrices into signal+interference subspace

if ~isfield(cfg,'threshold'),    cfg.threshold = 500; end
if ~isfield(cfg,'projection'),   cfg.projection = false; end

%% ==== NO IMPORT, PLOT THE ERRORS ====
cfg_study = [];
cfg_study.subject_name = 'Subject01';
cfg_study.condition_name = 'leadfield_errors';
if ~cfg.import
    study_idx = brainstorm.bstcust_study_id(cfg);
    brainstorm.bstcust_plot(study_idx, '0');    
    return
end

%% ==== COPY EEG DATA ====
if cfg.projection
    tag = 'leadfield_errors_proj';
else
    tag = 'leadfield_errors';
end
cfg_eeg = [];
cfg_eeg.data_file_in = 'output\sim_data_bem_1_100t\single_cort_src_1\0_1.mat';
cfg_eeg.data_file_out = fullfile('output', tag, 'eeg.mat');
[pathstr,~,~,~] = util.fileparts(cfg_eeg.data_file_out);
if ~exist(pathstr,'dir')
    mkdir(pathstr);
end
copyfile(cfg_eeg.data_file_in, cfg_eeg.data_file_out);

%% ==== CALCULATE PROJECTION MATRIX ====
if cfg.projection
    % Load the ERP data
    data_in = load(cfg_eeg.data_file_out);
    cfg_proj = [];
    cfg_proj.R = data_in.data.R;
    cfg_proj.n_interfering_sources = 0;
    P = aet_analysis_eig_projection(cfg_proj);
    clear data_in;
end
    
%% ==== CALCULATE LEADFIELD ERRORS ====
% Set up head model configs
cfg_head.current.type = 'brainstorm';
cfg_head.current.file = 'head_Default1_3sphere_500V.mat';
cfg_head.actual.type = 'brainstorm';
cfg_head.actual.file = 'head_Default1_bem_500V.mat';

% Get the head model data
cfg_lf = [];
cfg_lf.actual = hm_get_data(cfg_head.actual);
cfg_lf.estimate = hm_get_data(cfg_head.current);

n_locs = size(cfg_lf.actual.head.GridLoc,1);
% Allocate memory
error = zeros(n_locs,1);
for i=1:n_locs
    % Get the leadfield matrices at the current index
    cfg_lf.actual.loc = i;
    lf_actual = hm_get_leadfield(cfg_lf.head, cfg_lf.actual.loc);
    cfg_lf.estimate.loc = i;
    lf_estimate = hm_get_leadfield(cfg_lf.head, cfg_lf.estimate.loc);
    
    % Project the leadfields
    if cfg.projection
        lf_actual = P*lf_actual;
        lf_estimate = P*lf_estimate;
    end
    
    % Calculate the frobenius norm of the error matrix
    error(i,1) = norm(lf_actual - lf_estimate, 'fro');
end

% Threshold the data
error = error.*(error < cfg.threshold);
% error = log10(error);

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

%% ==== SAVE ERRORS TO FILE ====
% Have to fake a beamformer output file so I can reuse the bstcust import
% functions
source.beamformer_output = zeros(3, n_locs, length(eeg.Time));
source.beamformer_output(1,:,:) = repmat(error',[1 1 length(eeg.Time)]);
save_file = fullfile('output', tag,...
    ['eeg_' tag '_mini.mat']);
save(save_file,'source');

%% ==== IMPORT SOURCE RESULTS TO BRAINSTORM ====

cfg_db.source = source_template;
cfg_db.tags = {tag};
cfg_db = brainstorm.prep_import_source_auto(cfg_db);

%% ==== PLOT THE ERRORS ====
brainstorm.bstcust_plot(study_idx, '0');
    
end