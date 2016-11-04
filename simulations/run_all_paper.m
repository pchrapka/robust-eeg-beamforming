%% run_all_paper

%% Open the parallel pipeline
% set up parallel execution
lumberjack.parfor_setup();

%% Low res simulations for Output SINR vs Input SNR - mult src 17
% Spatial correlation of 0.5

% 5000 samples
sim_file = 'sim_data_bem_1_100t_5000s';
source_file = 'src_param_mult_cortical_source_17_lag40';
source_name = 'mult_cort_src_17_lag40';

run_sim_vars_bem_mult_paper_locs2(...
    sim_file, source_file, source_name,...
    'snrs',-10:5:30,...
    'hmconfigs',{'matched','mismatched','mismatched_perturbed'});

% plots
plot_sinr_mult_config_paper(...
    sim_file, source_name,...
    'snrs',-10:5:30,...
    'hmconfigs',{'matched','mismatched','mismatched_perturbed'});

% 1000 samples
sim_file = 'sim_data_bem_1_100t';
source_file = 'src_param_mult_cortical_source_17_lag40';
source_name = 'mult_cort_src_17_lag40';

run_sim_vars_bem_mult_paper_locs2(...
    sim_file, source_file, source_name,...
    'snrs',-10:5:30,...
    'hmconfigs',{'matched','mismatched','mismatched_perturbed'});

% plots
plot_sinr_mult_config_paper(...
    sim_file, source_name,...
    'snrs',-10:5:30,...
    'hmconfigs',{'matched','mismatched','mismatched_perturbed'});

%% Low res simulations for Output SINR vs Input SNR - mult src 18
% Spatial correlation of 0

% 5000 samples
sim_file = 'sim_data_bem_1_100t_5000s';
source_file = 'src_param_mult_cortical_source_18_lag40';
source_name = 'mult_cort_src_18_lag40';

run_sim_vars_bem_mult_paper_locs2(...
    sim_file, source_file, source_name,...
    'snrs',-10:5:30,...
    'hmconfigs',{'matched','mismatched','mismatched_perturbed'});

% plots
plot_sinr_mult_config_paper(...
    sim_file, source_name,...
    'snrs',-10:5:30,...
    'hmconfigs',{'matched','mismatched','mismatched_perturbed'});

% 1000 samples
sim_file = 'sim_data_bem_1_100t';
source_file = 'src_param_mult_cortical_source_18_lag40';
source_name = 'mult_cort_src_18_lag40';

run_sim_vars_bem_mult_paper_locs2(...
    sim_file, source_file, source_name,...
    'snrs',-10:5:30,...
    'hmconfigs',{'matched','mismatched','mismatched_perturbed'});

% plots
plot_sinr_mult_config_paper(...
    sim_file, source_name,...
    'snrs',-10:5:30,...
    'hmconfigs',{'matched','mismatched','mismatched_perturbed'});

%% HD 2 sources
% beampattern and sinr

sim_file = 'sim_data_bemhd_1_100t_5000s';
source_file = 'src_param_mult_cortical_source_17hd_lag40';
source_name = 'mult_cort_src_17hd_lag40';

% beampattern and sinr requires only 2 locs
run_sim_vars_bemhd_paper(...
    sim_file, source_file, source_name,...
    'config','mult-paper',...
    'locs',[5440,13841],...
    'snrs',[0,15,25],...
    'hmconfigs',{'matched','mismatched','mismatched_perturbed'});

% plots
% plot_beampattern_multhd_config_paper(...
%     sim_file, source_name,...
%     'hmconfigs',{'matched','mismatched','mismatched_perturbed'},...
%     'snr',0);
% 
% plot_beampattern_multhd_config_paper(...
%     sim_file, source_name,...
%     'hmconfigs',{'matched','mismatched','mismatched_perturbed'},...
%     'snr',15);

plot_beampattern_multhd_config_paper(...
    sim_file, source_name,...
    'hmconfigs',{'matched','mismatched','mismatched_perturbed'},...
    'snr',25);

%% HD 2 sources - power surface plots
% NOTE These take a while

sim_file = 'sim_data_bemhd_1_100t_5000s';
source_file = 'src_param_mult_cortical_source_17hd_lag40';
source_name = 'mult_cort_src_17hd_lag40';

run_sim_vars_bemhd_paper(...
    sim_file, source_file, source_name,...
    'config','mult-paper',...
    'locs','all',...
    'snrs',25,...
    'hmconfigs',{'matched','mismatched','mismatched_perturbed'});

plot_power_surface_bemhd_config_paper(...
    sim_file,source_name,...
    'config','mult-paper',...
    'hmconfigs',{'matched','mismatched','mismatched_perturbed'},...
    'snr',25);

%% HD single source - power surface plots
% NOTE These take a while

% sim_file = 'sim_data_bemhd_1_100t_5000s';
% source_file = 'src_param_single_cortical_source_1hd';
% source_name = 'single_cort_src_1hd';
% 
% run_sim_vars_bemhd_paper(...
%     sim_file, source_file, source_name,...
%     'config','single-paper',...
%     'locs','all',...
%     'snrs',15,...
%     'matched','both');
% 
% % plots
% plot_power_surface_bemhd_config_paper(...
%     sim_file,source_name,...
%     'config','single-paper',...
%     'matched','both',...
%     'snr',15);



