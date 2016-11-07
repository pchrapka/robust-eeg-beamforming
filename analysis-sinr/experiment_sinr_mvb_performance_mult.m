%% experiment_sinr_mvb_performance_mult
%
%   Goal:
%       Figure out why the MVB performance is not that great with
%       sim_data_bem_1_100t config

params = [];
k = 1;


params(k).sim_file = 'sim_data_bem_1_100t';
params(k).source_file = 'src_param_mult_cortical_source_17_lag40';
params(k).source_name = 'mult_cort_src_17_lag40';
k = k+1;

params(k).sim_file = 'sim_data_bem_1_100t_5000s';
params(k).source_file = 'src_param_mult_cortical_source_17_lag40';
params(k).source_name = 'mult_cort_src_17_lag40';
k = k+1;

params(k).sim_file = 'sim_data_bem_1_100t_5000s';
params(k).source_file = 'src_param_mult_cortical_source_17_lag40';
params(k).source_name = 'mult_cort_src_17_lag40';
k = k+1;

hmconfigs = {'matched','mismatched'};
plot_configs = {'matched-paper','mismatched-paper'};

for i=1:length(params)
    % Create data and beamformer analysis
    run_sim_vars_bem_mult_paper_locs2(...
        params(i).sim_file,params(i).source_file,params(i).source_name,'hmconfigs',hmconfigs);
    
    % Compute sinr vs snr 
    plot_sinr_mult_config_paper(...
        params(i).sim_file,params(i).source_name,...
        'datatag','locs2_covtime',...
        'PlotGroups',plot_configs);
end