%% analyze_dispersion

%% Common params
snr = '0';
mismatch = false;

%% Get the data file name
cfg = [];
cfg.sim_name = 'sim_data_bem_1_100t';
cfg.source_name = 'distr_cort_src_2';
cfg.snr = snr;
cfg.iteration = '1';
if mismatch
    cfg.tag = 'dispersion';
else
    cfg.tag = 'dispersion_3sphere';
end
data_file = db.save_setup(cfg_out);

%% Load data
data_in = load(data_file);