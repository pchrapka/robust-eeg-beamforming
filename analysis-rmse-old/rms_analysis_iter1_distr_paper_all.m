%% rms_analysis_iter1_distr_paper_all

%% Set up different rms analysis
% For distr source results with 1 iteration
cfg = [];
cfg.source_name = 'distr_cort_src_2';
cfg.location_idx = 295;
rms_analysis_iter1_distr_paper(cfg);

cfg = [];
cfg.source_name = 'distr_cort_src_2';
cfg.sample_idx = 250*0.464;
rms_analysis_iter1_distr_paper(cfg);

cfg = [];
cfg.source_name = 'distr_cort_src_2';
cfg.sample_idx = 120;
rms_analysis_iter1_distr_paper(cfg);

% Setup sample interval
sample_idxs = 105:135; %250*0.428:250*0.532;
for sample_idx=sample_idxs
    cfg = [];
    cfg.source_name = 'distr_cort_src_2';
    cfg.sample_idx = sample_idx;
    rms_analysis_iter1_distr_paper(cfg);
end

% Setup sample interval
sample_idxs = 105:135; %250*0.428:250*0.532;
for sample_idx=sample_idxs
    cfg = [];
    cfg.source_name = 'distr_cort_src_3';
    cfg.sample_idx = sample_idx;
    rms_analysis_iter1_distr_paper(cfg);
end

%% Summarize the results and place in one csv file
snr = 0;

rms_analysis_iter1_summary('distr_cort_src_2',snr);
rms_analysis_iter1_summary('distr_cort_src_3',snr);