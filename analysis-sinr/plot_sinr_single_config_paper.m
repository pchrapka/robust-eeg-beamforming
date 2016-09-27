function plot_sinr_single_config_paper(source_name)

force = true;
params = [];
k = 1;

params(k).beamformer_configs = {...
    'rmv_epsilon_20_locs1',...
    'rmv_eig_pre_cov_0_epsilon_20_locs1',...
    'lcmv_locs1',...
    'lcmv_eig_cov_0_locs1',...
    'lcmv_reg_eig_locs1',...
    };
params(k).tag = '-paper';
params(k).matched = true;
k = k+1;

params(k).beamformer_configs = {...
    'rmv_epsilon_100_locs1_3sphere',...
    'rmv_epsilon_150_locs1_3sphere',...
    'rmv_epsilon_200_locs1_3sphere',...
    ...'rmv_eig_pre_cov_0_epsilon_100_locs1_3sphere',...
    'rmv_eig_pre_cov_0_epsilon_150_locs1_3sphere',...
    ...'rmv_eig_pre_cov_0_epsilon_200_locs1_3sphere',...
    'rmv_aniso_eig_pre_cov_0_locs1_3sphere',...
    'rmv_aniso_locs1_3sphere',...
    'lcmv_locs1_3sphere',...
    'lcmv_eig_cov_0_locs1_3sphere',...
    'lcmv_reg_eig_locs1_3sphere',...
    };
params(k).tag = '-paper';
params(k).matched = false;
k = k+1;

for i=1:length(params)
    data_set = SimDataSetEEG(...
        'sim_data_bem_1_100t',...
        source_name,...
        0,...
        'iter',1);
    
    % signal location, oSNR vs iSNR
    plot_metric_output_vs_input_group(...
        data_set,...
        params(i).beamformer_configs,...
        295,...
        'savetag',params(i).tag,...
        'matched',params(i).matched,...
        'metricx','input snr',...
        'metricy','output snr',...
        'snrs',-20:5:20,...
        'force',force...
        );
end

end