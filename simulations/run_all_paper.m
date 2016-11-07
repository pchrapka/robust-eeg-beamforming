%% run_all_paper

%% Open the parallel pipeline
% set up parallel execution
lumberjack.parfor_setup();

%% Low res simulations for Output SINR vs Input SNR - mult src 17
% Spatial correlation of 0.5

k=1;
params = [];

%mult src 17 - Spatial correlation of 0.5
% 5000 samples
params(k).sim_file = 'sim_data_bem_1_100t_5000s';
params(k).source_file = 'src_param_mult_cortical_source_17_lag40';
params(k).source_name = 'mult_cort_src_17_lag40';
k = k+1;

% 1000 samples
params(k).sim_file = 'sim_data_bem_1_100t';
params(k).source_file = 'src_param_mult_cortical_source_17_lag40';
params(k).source_name = 'mult_cort_src_17_lag40';
k = k+1;

%mult src 18 - Spatial correlation of 0
% 5000 samples
params(k).sim_file = 'sim_data_bem_1_100t_5000s';
params(k).source_file = 'src_param_mult_cortical_source_18_lag40';
params(k).source_name = 'mult_cort_src_18_lag40';
k = k+1;

% 1000 samples
params(k).sim_file = 'sim_data_bem_1_100t';
params(k).source_file = 'src_param_mult_cortical_source_18_lag40';
params(k).source_name = 'mult_cort_src_18_lag40';
k = k+1;

for i=1:length(params)
    run_sim_vars_bem_mult_paper_locs2(...
        params(k).sim_file, params(k).source_file, params(k).source_name,...
        'snrs',-10:5:30,...
        'cov_type','time',...
        'hmconfigs',{'matched','mismatched'});
    
    plot_sinr_mult_config_paper(...
        params(k).sim_file, params(k).source_name,...
        'snrs',-10:5:30,...
        'datatag','locs2_covtime',...
        'PlotGroups',{'matched-paper','mismatched-paper'});
    
    % perturbed
    run_sim_vars_bem_mult_paper_locs2(...
        params(k).sim_file, params(k).source_file, params(k).source_name,...
        'snrs',-10:5:30,...
        'cov_type','time',...
        'hmconfigs',{'mismatched'},...
        'perturb','perturb0.10');
    
    plot_sinr_mult_config_paper(...
        params(k).sim_file, params(k).source_name,...
        'snrs',-10:5:30,...
        'datatag','locs2_covtime_perturb0.10',...
        'PlotGroups',{'mismatched-paper-perturbed'});
end

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
    'snrs',25,...
    'hmconfigs',{'matched','mismatched'});

plot_beampattern_multhd_config_paper(...
    sim_file, source_name,...
    'datatag','locs2_covtime',...
    'PlotGroups',{'matched-beampattern','mismatched-beampattern'},...
    'snr',25);

run_sim_vars_bemhd_paper(...
    sim_file, source_file, source_name,...
    'config','mult-paper',...
    'locs',[5440,13841],...
    'snrs',25,...
    'perturb','perturb0.10',...
    'hmconfigs',{'mismatched'});

plot_beampattern_multhd_config_paper(...
    sim_file, source_name,...
    'datatag','locs2_covtime_perturb0.10',...
    'PlotGroups',{'mismatched-beampattern-perturbed'},...
    'snr',25);

%% HD 2 sources - power surface plots
% NOTE These take a while

sim_file = 'sim_data_bemhd_1_100t_5000s';
source_file = 'src_param_mult_cortical_source_17hd_lag40';
source_name = 'mult_cort_src_17hd_lag40';

% beampattern and sinr requires only 2 locs
run_sim_vars_bemhd_paper(...
    sim_file, source_file, source_name,...
    'config','mult-paper',...
    'locs','all',...
    'snrs',25,...
    'hmconfigs',{'matched','mismatched'});

plot_power_surface_bemhd_config_paper(...
    sim_file,source_name,...
    'datatag','locsall_covtime',...
    'PlotGroups',{'matched-power','mismatched-power'},...
    'snr',25);

run_sim_vars_bemhd_paper(...
    sim_file, source_file, source_name,...
    'config','mult-paper',...
    'locs','all',...
    'snrs',25,...
    'perturb','perturb0.10',...
    'hmconfigs',{'mismatched'});

plot_power_surface_bemhd_config_paper(...
    sim_file,source_name,...
    'datatag','locsall_covtime_perturb0.10',...
    'PlotGroups',{'mismatched-power-perturbed'},...
    'snr',25);



