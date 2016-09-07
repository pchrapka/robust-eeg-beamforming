%% rms_analysis_iter1_single_paper_all

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
sample_idxs = 105:135; %250*0.428:250*0.532;
for sample_idx=sample_idxs
    cfg = [];
    cfg.source_name = 'single_cort_src_1';
    cfg.sample_idx = sample_idx;
    rms_analysis_iter1_single_paper(cfg);
end

%% Summarize the results and place in one csv file
cfg = [];
cfg.source_name = 'single_cort_src_1';
rms_analysis_iter1_summary(cfg);