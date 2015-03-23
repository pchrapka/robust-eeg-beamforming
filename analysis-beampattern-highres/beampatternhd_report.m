%% beampattern_report

%% Generate data
% run_sim_vars_bemhd_paper_mult17hd

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SNR = 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Compute beampatterns - matched

matched = true;
snr = 0;
cfg = compute_beampatternhd_mult17hd(matched, snr);

%% Plot data

plot_beampatternhd_mult17hd(cfg);
close all

%% Compute beampatterns - mismatched

matched = false;
snr = 0;
cfg = compute_beampatternhd_mult17hd(matched, snr);

%% Plot data

plot_beampatternhd_mult17hd(cfg);
close all

%% Plot beampattern diff - matched
cfg = [];
cfg.beamcfga = 'rmv_epsilon_20';
cfg.beamcfgb = 'lcmv';
plot_beampatternhd_diff_mult17hd(cfg);

cfg = [];
cfg.beamcfga = 'rmv_epsilon_30';
cfg.beamcfgb = 'rmv_epsilon_20';
plot_beampatternhd_diff_mult17hd(cfg);
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SNR = -20
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Compute beampatterns - matched

matched = true;
snr = -20;
cfg = compute_beampatternhd_mult17hd(matched, snr);

%% Plot data

plot_beampatternhd_mult17hd(cfg);
close all

%% Compute beampatterns - mismatched

matched = false;
snr = -20;
cfg = compute_beampatternhd_mult17hd(matched, snr);

%% Plot data

plot_beampatternhd_mult17hd(cfg);
close all