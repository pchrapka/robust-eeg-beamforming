%% beampattern_report

%% Generate data
run_sim_vars_bemhd_paper_mult17hd

%% Compute beampatterns - matched

matched = true;
cfg = compute_beampatternhd_mult17hd(matched);

%% Plot data

plot_beampatternhd_mult17hd(cfg);

%% Compute beampatterns - mismatched

matched = false;
cfg = compute_beampatternhd_mult17hd(matched);

%% Plot data

plot_beampatternhd_mult17hd(cfg);