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
cfg = get_power_surface_config('highres',source_name, matched, snr);

%% Plot data
plot_power_surface(cfg.data_set, cfg.beam_cfgs, 'sample', sample, cfg.args{:});

%% Compute beamformer output power - mismatched

matched = false;
cfg = get_power_surface_config('highres',source_name, matched, snr);

%% Plot data
plot_power_surface(cfg.data_set, cfg.beam_cfgs, 'sample', sample, cfg.args{:});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Single1HD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

source_name = 'single_cort_src_1hd';
snr = 0;
time = 0.476;
sample = time*250 + 1;

%% Compute beamformer output power - matched

matched = true;
cfg = get_power_surface_config('highres',source_name, matched, snr);

%% Plot data
plot_power_surface(cfg.data_set, cfg.beam_cfgs, 'sample', sample, cfg.args{:});

%% Compute beamformer output power - mismatched

matched = false;
cfg = get_power_surface_config('highres',source_name, matched, snr);

%% Plot data
plot_power_surface(cfg.data_set, cfg.beam_cfgs, 'sample', sample, cfg.args{:});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Distr2HD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

source_name = 'distr_cort_src_2hd';
snr = 0;
time = 0.464;
sample = time*250 + 1;

%% Compute beamformer output power - matched

matched = true;
cfg = get_power_surface_config('highres',source_name, matched, snr);

%% Plot data
plot_power_surface(cfg.data_set, cfg.beam_cfgs, 'sample', sample, cfg.args{:});

%% Compute beamformer output power - mismatched

matched = false;
cfg = get_power_surface_config('highres',source_name, matched, snr);

%% Plot data
plot_power_surface(cfg.data_set, cfg.beam_cfgs, 'sample', sample, cfg.args{:});
