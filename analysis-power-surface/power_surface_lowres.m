%% power_surface_lowres
% Beamformer output power plotted on the cortex at a particular point in
% time, using a low resolution head model.
%
% These are the low res version of those used in the paper
%
% See also, RUN_ALL_PAPER

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Mult17
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

source_name = 'mult_cort_src_17';
snr = 0;
time = 0.520;
sample = time*250 + 1;

%% Compute beamformer output power - matched

matched = true;
cfg = get_power_surface_config('lowres',source_name, matched, snr);

%% Plot data
plot_power_surface(cfg.data_set, cfg.beam_cfgs, 'sample', sample, cfg.args{:});

%% Compute beamformer output power - mismatched

matched = false;
cfg = get_power_surface_config('lowres',source_name, matched, snr);

%% Plot data
plot_power_surface(cfg.data_set, cfg.beam_cfgs, 'sample', sample, cfg.args{:});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Single1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

source_name = 'single_cort_src_1';
snr = 0;
time = 0.476;
sample = time*250 + 1;

%% Compute beamformer output power - matched

matched = true;
cfg = get_power_surface_config('lowres',source_name, matched, snr);

%% Plot data
plot_power_surface(cfg.data_set, cfg.beam_cfgs, 'sample', sample, cfg.args{:});

%% Compute beamformer output power - mismatched

matched = false;
cfg = get_power_surface_config('lowres',source_name, matched, snr);

%% Plot data
plot_power_surface(cfg.data_set, cfg.beam_cfgs, 'sample', sample, cfg.args{:});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Distr2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

source_name = 'distr_cort_src_2';
snr = 0;
time = 0.464;
sample = time*250 + 1;

%% Compute beamformer output power - matched

matched = true;
cfg = get_power_surface_config('lowres',source_name, matched, snr);

%% Plot data
plot_power_surface(cfg.data_set, cfg.beam_cfgs, 'sample', sample, cfg.args{:});

%% Compute beamformer output power - mismatched

matched = false;
cfg = get_power_surface_config('lowres',source_name, matched, snr);

%% Plot data
plot_power_surface(cfg.data_set, cfg.beam_cfgs, 'sample', sample, cfg.args{:});
