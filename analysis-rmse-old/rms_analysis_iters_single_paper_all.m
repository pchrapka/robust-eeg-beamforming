%% rms_analysis_iters_single_paper_all

%% Set up different rms analysis 
% Single source results with multiple iterations
cfg = [];
cfg.location_idx = 295;
rms_analysis_iters_single_paper(cfg);

cfg = [];
cfg.sample_idx = 250*0.476;
rms_analysis_iters_single_paper(cfg);