%% analyze_dispersion
clc;

%% Common params
snr = '0';
mismatch = true;

%% Get the data file name
cfg = [];
cfg.sim_name = 'sim_data_bem_1_100t';
cfg.source_name = 'distr_cort_src_2';
% cfg.source_name = 'single_cort_src_1';
cfg.snr = snr;
cfg.iteration = '1';
if mismatch
    cfg.tag = 'dispersion_3sphere';
else
    cfg.tag = 'dispersion';
end
data_file = db.save_setup(cfg);

%% Load data
data_in = load(data_file);
results = data_in.dispersion_data;

%% Display the results
% results.name = results.name';
% results.value = results.value';
M = [results.name; results.value];
fprintf('%s %f\n',M{:});