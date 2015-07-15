%% power_surface_highres
% Beamformer output power plotted on the cortex at a particular point in
% time, using a high resolution head model.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Mult17HD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

source_name = 'mult_cort_src_17hd';
snr = 0;
time = 0.520;
sample = time*250 + 1;

%% Compute beamformer output power - matched

matched = true;
cfg = compute_power_surface_mult17hd(matched, snr);
% TODO refactor to compute_power_surface_highres, use lowres as an example

cfgview = [];
cfgview.datafiles = cfg.outputfile;
cfgview.head = cfg.head;
cfgview.sample = sample;
cfgview.data_set = cfg.data_set;
view_power_surface_relative(cfgview);

%% Compute beamformer output power - mismatched

matched = false;
cfg = compute_power_surface_mult17hd(matched, snr);

cfgview = [];
cfgview.datafiles = cfg.outputfile;
cfgview.head = cfg.head;
cfgview.sample = sample;
cfgview.data_set = cfg.data_set;
view_power_surface_relative(cfgview);

