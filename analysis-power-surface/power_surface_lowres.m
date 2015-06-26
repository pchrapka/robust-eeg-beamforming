%% power_surface_paper

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Mult17
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

source_name = 'mult_cort_src_17';
snr = 0;
time = 0.520;
sample = time*250 + 1;

%% Compute beamformer output power - matched

matched = true;
cfg = compute_power_surface_lowres(source_name, matched, snr);

cfgview = [];
cfgview.datafiles = cfg.outputfile;
cfgview.head = cfg.head;
cfgview.sample = sample;
cfgview.data_set = cfg.data_set;
view_power_surface_relative(cfgview);

%% Compute beamformer output power - mismatched

matched = false;
cfg = compute_power_surface_lowres(source_name, matched, snr);

cfgview = [];
cfgview.datafiles = cfg.outputfile;
cfgview.head = cfg.head;
cfgview.sample = sample;
cfgview.data_set = cfg.data_set;
view_power_surface_relative(cfgview);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Single1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

source_name = 'single_cort_src_1';
snr = 0;
time = 0.476;
sample = time*250 + 1;

%% Compute beamformer output power - matched

matched = true;
cfg = compute_power_surface_lowres(source_name, matched, snr);

%% Plot data
cfgview = [];
cfgview.datafiles = cfg.outputfile;
cfgview.head = cfg.head;
cfgview.sample = sample;
cfgview.data_set = cfg.data_set;
view_power_surface_relative(cfgview);

%% Compute beamformer output power - mismatched

matched = false;
cfg = compute_power_surface_lowres(source_name, matched, snr);

%% Plot data
cfgview = [];
cfgview.datafiles = cfg.outputfile;
cfgview.head = cfg.head;
cfgview.sample = sample;
cfgview.data_set = cfg.data_set;
view_power_surface_relative(cfgview);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Distr2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

source_name = 'distr_cort_src_2';
snr = 0;
time = 0.464;
sample = time*250 + 1;

%% Compute beamformer output power - matched

matched = true;
cfg = compute_power_surface_lowres(source_name, matched, snr);

%% Plot data
cfgview = [];
cfgview.datafiles = cfg.outputfile;
cfgview.head = cfg.head;
cfgview.sample = sample;
cfgview.data_set = cfg.data_set;
view_power_surface_relative(cfgview);

%% Compute beamformer output power - mismatched

matched = false;
cfg = compute_power_surface_lowres(source_name, matched, snr);

%% Plot data
cfgview = [];
cfgview.datafiles = cfg.outputfile;
cfgview.head = cfg.head;
cfgview.sample = sample;
cfgview.data_set = cfg.data_set;
view_power_surface_relative(cfgview);
