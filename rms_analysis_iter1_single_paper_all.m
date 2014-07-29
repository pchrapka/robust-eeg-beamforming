%% rms_analysis_iter1_single_paper_all

%% Update AET, just in case
update_aet()

%% Initialize the Advanced EEG Toolbox
aet_init

%% Set up different rms analysis 
% Single source results with 1 iteration
cfg = [];
cfg.source_name = 'single_cort_src_1';
cfg.location_idx = 295;
rms_analysis_iter1_single_paper(cfg);

cfg = [];
cfg.source_name = 'single_cort_src_1';
cfg.sample_idx = 250*0.476;
rms_analysis_iter1_single_paper(cfg);

cfg = [];
cfg.source_name = 'single_cort_src_1';
cfg.sample_idx = 120;
rms_analysis_iter1_single_paper(cfg);

% Setup sample interval
location_idxs = 105:135;%250*0.428:250*0.532;
for location_idx=location_idxs
    cfg = [];
    cfg.source_name = 'single_cort_src_1';
    cfg.sample_idx = location_idx;
    rms_analysis_iter1_single_paper(cfg);
end

%% Summarize the results and place in one csv file
cfg = [];
cfg.source_name = 'single_cort_src_1';
rms_analysis_iter1_summary(cfg);