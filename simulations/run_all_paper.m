%% run_all_paper

%% Open the parallel pipeline
% set up parallel execution
lumberjack.parfor_setup();

%% Low res simulations for Output SINR vs Input SNR

% 5000 samples
sim_file = 'sim_data_bem_1_100t_5000s';
source_file = 'src_param_mult_cortical_source_17_lag40';
source_name = 'mult_cort_src_17_lag40';

run_sim_vars_bem_mult_paper_locs2(...
    sim_file, source_file, source_name,...
    'snrs',-10:5:30,...
    'matched','both');

% plots
plot_sinr_mult_config_paper(...
    sim_file, source_name,...
    'snrs',-10:5:30,...
    'matched','both');

% 1000 samples
sim_file = 'sim_data_bem_1_100t';
source_file = 'src_param_mult_cortical_source_17_lag40';
source_name = 'mult_cort_src_17_lag40';

run_sim_vars_bem_mult_paper_locs2(...
    sim_file, source_file, source_name,...
    'snrs',-10:5:30,...
    'matched','both');

% plots
plot_sinr_mult_config_paper(...
    sim_file, source_name,...
    'snrs',-10:5:30,...
    'matched','both');

%% HD 2 sources
% beampattern and power surface plots

sim_file = 'sim_data_bemhd_1_100t_5000s';
source_file = 'src_param_mult_cortical_source_17hd_lag40';
source_name = 'mult_cort_src_17hd_lag40';

run_sim_vars_bemhd_paper_locsall(...
    sim_file, source_file, source_name,...
    'config','mult-paper',...
    'snrs',15,...
    'matched','both');

% plots
plot_beampattern_multhd_config_paper(...
    sim_file, source_name,...
    'matched','both',...
    'snr',15);

plot_power_surface_bemhd_config_paper(...
    sim_file,source_name,...
    'config','mult-paper',...
    'matched','both',...
    'snr',15);

%% HD single source
% power surface plots

sim_file = 'sim_data_bemhd_1_100t_5000s';
source_file = 'src_param_single_cortical_source_1hd';
source_name = 'single_cort_src_1hd';

run_sim_vars_bemhd_paper_locsall(...
    sim_file, source_file, source_name,...
    'config','single-paper',...
    'snrs',15,...
    'matched','both');

% plots
plot_power_surface_bemhd_config_paper(...
    sim_file,source_name,...
    'config','single-paper',...
    'matched','both',...
    'snr',15);

% run_sim_vars_bemhd_distr2hd_paper



