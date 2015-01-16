%% rms_analysis_iters_distr_paper_all

%% Update AET, just in case
util.update_aet();

%% Initialize the Advanced EEG Toolbox
aet_init

%% Set up different rms analysis
% For distr source results with multiple iterations
cfg = [];
cfg.location_idx = 295;
rms_analysis_iters_distr_paper(cfg);

cfg = [];
cfg.sample_idx = 250*0.464;
rms_analysis_iters_distr_paper(cfg);