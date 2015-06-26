%% power_surface_report

%% Generate data
% run_sim_vars_bemhd_paper_mult17hd

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SNR = 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Compute beamformer output power - matched

matched = true;
snr = 0;
time = 0.520;
sample = time*250 + 1;
cfg = compute_power_surface_mult17hd(matched, snr);

%% Plot data

cfgview = [];
cfgview.datafiles = cfg.outputfile;
cfgview.head = cfg.head;
cfgview.sample = sample;
cfgview.data_set = cfg.data_set;
view_power_surface_relative(cfgview);

%% Compute beamformer output power - mismatched

matched = false;
snr = 0;
time = 0.520;
sample = time*250 + 1;
cfg = compute_power_surface_mult17hd(matched, snr);

%% Plot data

cfgview = [];
cfgview.datafiles = cfg.outputfile;
cfgview.head = cfg.head;
cfgview.sample = sample;
cfgview.data_set = cfg.data_set;
view_power_surface_relative(cfgview);