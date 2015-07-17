%% power_surface_highres
% Beamformer output power plotted on the cortex at a particular point in
% time, using a high resolution head model.
%
% These are the plots used in the paper
%
% See also, RUN_ALL_PAPER

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Mult17HD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

source_name = 'mult_cort_src_17hd';
snr = 0;
time = 0.520;
sample = time*250 + 1;

%% Compute beamformer output power - matched

matched = true;
cfg = compute_power_surface_highres(source_name, matched, snr);

cfgview = [];
cfgview.datafiles = cfg.outputfile;
cfgview.head = cfg.head;
cfgview.sample = sample;
cfgview.data_set = cfg.data_set;
view_power_surface_relative(cfgview);

%% Compute beamformer output power - mismatched

matched = false;
cfg = compute_power_surface_highres(source_name, matched, snr);

cfgview = [];
cfgview.datafiles = cfg.outputfile;
cfgview.head = cfg.head;
cfgview.sample = sample;
cfgview.data_set = cfg.data_set;
view_power_surface_relative(cfgview);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Single1HD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

source_name = 'single_cort_src_1hd';
snr = 0;
time = 0.476;
sample = time*250 + 1;

%% Compute beamformer output power - matched

matched = true;
cfg = compute_power_surface_highres(source_name, matched, snr);

%% Plot data
cfgview = [];
cfgview.datafiles = cfg.outputfile;
cfgview.head = cfg.head;
cfgview.sample = sample;
cfgview.data_set = cfg.data_set;
view_power_surface_relative(cfgview);

%% Compute beamformer output power - mismatched

matched = false;
cfg = compute_power_surface_highres(source_name, matched, snr);

%% Plot data
cfgview = [];
cfgview.datafiles = cfg.outputfile;
cfgview.head = cfg.head;
cfgview.sample = sample;
cfgview.data_set = cfg.data_set;
view_power_surface_relative(cfgview);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Distr2HD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

source_name = 'distr_cort_src_2hd';
snr = 0;
time = 0.464;
sample = time*250 + 1;

%% Compute beamformer output power - matched

matched = true;
cfg = compute_power_surface_highres(source_name, matched, snr);

%% Plot data
cfgview = [];
cfgview.datafiles = cfg.outputfile;
cfgview.head = cfg.head;
cfgview.sample = sample;
cfgview.data_set = cfg.data_set;
view_power_surface_relative(cfgview);

%% Compute beamformer output power - mismatched

matched = false;
cfg = compute_power_surface_highres(source_name, matched, snr);

%% Plot data
cfgview = [];
cfgview.datafiles = cfg.outputfile;
cfgview.head = cfg.head;
cfgview.sample = sample;
cfgview.data_set = cfg.data_set;
view_power_surface_relative(cfgview);
