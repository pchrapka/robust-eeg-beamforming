function metric_analysis_sinr_lcmveigvariations(source_name)

force = true;

%% Compute sinr
params = [];
k = 1;

params(k).beamformer_configs = {...
    'lcmv',...
    'lcmv_eig_cov_0',...
    'lcmv_eig_cov_1',...
    'lcmv_eig_cov_2',...
    'lcmv_eig_cov_5',...
    'lcmv_eig_cov_10',...
    'lcmv_eig_cov_20',...
    'lcmv_reg_eig',...
    };
params(k).tag = '-lcmveigvariations';
params(k).matched = true;
k = k+1;

params(k).beamformer_configs = {...
    'lcmv',...
    'lcmv_eig_cov_0',...
    'lcmv_eig_cov_1',...
    'lcmv_eig_cov_2',...
    'lcmv_eig_cov_0_reg_eig',...
    'lcmv_eig_cov_1_reg_eig',...
    'lcmv_eig_cov_2_reg_eig',...
    'lcmv_eig_cov_5_reg_eig',...
    'lcmv_eig_cov_10_reg_eig',...
    'lcmv_eig_cov_20_reg_eig',...
    'lcmv_reg_eig',...
    };
params(k).tag = '-lcmveigregvariations';
params(k).matched = true;
k = k+1;

params(k).beamformer_configs = {...
    'lcmv_3sphere',...
    'lcmv_eig_cov_0_3sphere',...
    'lcmv_eig_cov_1_3sphere',...
    'lcmv_eig_cov_2_3sphere',...
    'lcmv_eig_cov_5_3sphere',...
    'lcmv_eig_cov_10_3sphere',...
    'lcmv_eig_cov_20_3sphere',...
    'lcmv_reg_eig_3sphere',...
    };
params(k).tag = '-lcmveigvariations';
params(k).matched = false;
k = k+1;

for i=1:length(params)
    data_set = SimDataSetEEG(...
        'sim_data_bem_1_100t',...
        source_name,...
        0,...
        'iter',1);
    
    plot_metric_output_vs_input_group(...
        data_set,...
        params(i).beamformer_configs,...
        295,...
        'savetag',params(i).tag,...
        'matched',params(i).matched,...
        'metricx','input snr',...
        'metricy','output sinr',...
        'snrs',-20:10:20,...
        'force',force...
        );
    
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
    
    plot_metric_output_vs_input_group(...
        data_set,...
        params(i).beamformer_configs,...
        400,...
        'savetag',params(i).tag,...
        'matched',params(i).matched,...
        'metricx','input snr',...
        'metricy','output isnr',...
        'snrs',-20:10:20,...
        'force',force...
        );
end
end