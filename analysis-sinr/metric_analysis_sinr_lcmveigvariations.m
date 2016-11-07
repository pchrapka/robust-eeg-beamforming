function metric_analysis_sinr_lcmveigvariations(source_name)

force = true;

%% Compute sinr
params = [];
k = 1;

params(k).beamformer_configs = {...
    'lcmv_locs2',...
    'lcmv_eig_cov_0_locs2',...
    'lcmv_eig_cov_1_locs2',...
    'lcmv_eig_cov_2_locs2',...
    'lcmv_eig_cov_5_locs2',...
    'lcmv_eig_cov_10_locs2',...
    'lcmv_eig_cov_20_locs2',...
    'lcmv_reg_eig_locs2',...
    };
params(k).tag = '-lcmveigvariations';
params(k).matched = true;
k = k+1;

params(k).beamformer_configs = {...
    'lcmv_locs2',...
    'lcmv_eig_cov_0_locs2',...
    'lcmv_eig_cov_1_locs2',...
    'lcmv_eig_cov_2_locs2',...
    'lcmv_eig_cov_0_reg_eig_locs2',...
    'lcmv_eig_cov_1_reg_eig_locs2',...
    'lcmv_eig_cov_2_reg_eig_locs2',...
    'lcmv_eig_cov_5_reg_eig_locs2',...
    'lcmv_eig_cov_10_reg_eig_locs2',...
    'lcmv_eig_cov_20_reg_eig_locs2',...
    'lcmv_reg_eig_locs2',...
    };
params(k).tag = '-lcmveigregvariations';
params(k).matched = true;
k = k+1;

params(k).beamformer_configs = {...
    'lcmv_locs2_3sphere',...
    'lcmv_eig_cov_0_locs2_3sphere',...
    'lcmv_eig_cov_1_locs2_3sphere',...
    'lcmv_eig_cov_2_locs2_3sphere',...
    'lcmv_eig_cov_5_locs2_3sphere',...
    'lcmv_eig_cov_10_locs2_3sphere',...
    'lcmv_eig_cov_20_locs2_3sphere',...
    'lcmv_reg_eig_locs2_3sphere',...
    };
params(k).tag = '-lcmveigvariations';
params(k).matched = false;
k = k+1;

for i=1:length(params)
    data_set = SimDataSetEEG(...
        'sim_data_bem_1_100t_1000s',...
        source_name,...
        0,...
        'iter',1);
    
    plot_metric_output_vs_input_group(...
        data_set,...
        params(i).beamformer_configs,...
        295,...
        'savetag',params(i).tag,...
        'matched',params(i).matched,...
        'metricx','snr-input',...
        'metricy','sinr-beamformer-output',...
        'snrs',-20:10:20,...
        'force',force...
        );
    
    plot_metric_output_vs_input_group(...
        data_set,...
        params(i).beamformer_configs,...
        295,...
        'savetag',params(i).tag,...
        'matched',params(i).matched,...
        'metricx','snr-input',...
        'metricy', 'snr-beamformer-output',...
        'snrs',-20:5:20,...
        'force',force...
        );
    
    plot_metric_output_vs_input_group(...
        data_set,...
        params(i).beamformer_configs,...
        400,...
        'savetag',params(i).tag,...
        'matched',params(i).matched,...
        'metricx','snr-input',...
        'metricy','isnr-beamformer-output',...
        'snrs',-20:10:20,...
        'force',force...
        );
end
end
