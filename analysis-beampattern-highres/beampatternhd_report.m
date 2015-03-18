%% beampattern_report

%% Generate data
run_sim_vars_bemhd_paper_mult17hd

%% Compute beampatterns - matched

matched = true;
cfg = compute_beampatternhd_mult17hd(matched);

%% Plot data

cfgplt = [];
cfgplt.db = false;
cfgplt.normalize = false;
cfgplt.files = cfg.outputfile;
plot_beampattern(cfgplt);

cfgplt = [];
cfgplt.files = cfg.outputfile;
cfgplt.head = cfg.head;
cfgplt.options.scale = 'globalabsolute';
plot_beampattern3d(cfgplt);

%% Compute beampatterns - mismatched

matched = false;
cfg = compute_beampatternhd_mult17hd(matched);

%% Plot data

cfgplt = [];
cfgplt.db = false;
cfgplt.normalize = false;
cfgplt.files = cfg.outputfile;
plot_beampattern(cfgplt);

cfgplt = [];
cfgplt.files = cfg.outputfile;
cfgplt.head = cfg.head;
cfgplt.options.scale = 'globalabsolute';
plot_beampattern3d(cfgplt);

