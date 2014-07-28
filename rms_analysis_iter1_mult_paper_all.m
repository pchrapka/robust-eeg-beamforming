%% rms_analysis_iter1_mult_paper_all

%% Update AET, just in case
update_aet()

%% Initialize the Advanced EEG Toolbox
aet_init

%% Set up different rms analysis 
% Mult source results with 1 iteration
cfg = [];
cfg.location_idx = 295;
rms_analysis_iter1_mult_paper(cfg);

cfg = [];
cfg.location_idx = 400;
rms_analysis_iter1_mult_paper(cfg);

cfg = [];
cfg.sample_idx = 250*0.460;
rms_analysis_iter1_mult_paper(cfg);