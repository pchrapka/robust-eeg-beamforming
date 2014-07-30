%% rms_analysis_iter1_mult_paper_all

%% Update AET, just in case
util.update_aet();

%% Initialize the Advanced EEG Toolbox
aet_init

%% Set up different rms analysis 
% Mult source results with 1 iteration
% cfg = [];
% cfg.source_name = 'mult_cort_src_10';
% cfg.location_idx = 295;
% rms_analysis_iter1_mult_paper(cfg);
% 
% cfg = [];
% cfg.source_name = 'mult_cort_src_10';
% cfg.location_idx = 400;
% rms_analysis_iter1_mult_paper(cfg);
% 
% cfg = [];
% cfg.source_name = 'mult_cort_src_10';
% cfg.sample_idx = 250*0.460;
% rms_analysis_iter1_mult_paper(cfg);

cfg = [];
cfg.source_name = 'mult_cort_src_17';
cfg.location_idx = 295;
rms_analysis_iter1_mult_paper(cfg);

cfg = [];
cfg.source_name = 'mult_cort_src_17';
cfg.location_idx = 400;
rms_analysis_iter1_mult_paper(cfg);

% Setup sample interval
sample_idxs = 105:135; %250*0.428:250*0.532;
for sample_idx=sample_idxs
    cfg = [];
    cfg.source_name = 'mult_cort_src_17';
    cfg.sample_idx = sample_idx;
    rms_analysis_iter1_mult_paper(cfg);
end

%% Summarize the results and place in one csv file
cfg = [];
cfg.source_name = 'mult_cort_src_17';
rms_analysis_iter1_summary(cfg);