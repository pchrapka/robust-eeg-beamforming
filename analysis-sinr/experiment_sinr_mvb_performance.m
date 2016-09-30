%% experiment_sinr_mvb_performance
%
%   Goal:
%       Figure out why the MVB performance is not that great with
%       sim_data_bem_1_100t config

params = [];
k = 1;

% 
% params(k).sim_file = 'sim_data_bem_1_100t';
% params(k).source_file = 'src_param_single_cortical_source_sine_2';
% params(k).source_name = 'single_cort_src_sine_2';
% k = k+1;
% 
% params(k).sim_file = 'sim_data_bem_1_100t';
% params(k).source_file = 'src_param_single_cortical_source_sine_2_noise_white';
% params(k).source_name = 'single_cort_src_sine_2_noise_white';
% k = k+1;
% 
% params(k).sim_file = 'sim_data_bem_1_500t';
% params(k).source_file = 'src_param_single_cortical_source_sine_2_noise_white';
% params(k).source_name = 'single_cort_src_sine_2_noise_white';
% k = k+1;
% 
% params(k).sim_file = 'sim_data_bem_1_100t_5000s';
% params(k).source_file = 'src_param_single_cortical_source_sine_2_noise_white';
% params(k).source_name = 'single_cort_src_sine_2_noise_white';
% k = k+1;

params(k).sim_file = 'sim_data_bem_1_100t_5000s';
params(k).source_file = 'src_param_single_cortical_source_sine_2';
params(k).source_name = 'single_cort_src_sine_2';
k = k+1;

option_matched = 'matched';

for i=1:length(params)
    % Create data and beamformer analysis
    run_sim_vars_bem_single_paper_locs1(...
        params(i).sim_file,params(i).source_file,params(i).source_name,'matched',option_matched);
    
    % Compute sinr vs snr
    metric_analysis_sinr_single_sine_2(...
        params(i).sim_file,params(i).source_name);
    
    plot_sinr_single_config_paper(...
        params(i).sim_file,params(i).source_name,'matched',option_matched);
end