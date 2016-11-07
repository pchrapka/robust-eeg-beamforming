%% metric_analysis_sinr_mult17_lag40_pinvvariations

%% Data
% To generate data run the following script:

% run_sim_vars_bem_mult17_lag40_locs2_pinvvariations

%% Compute sinr
force = true;
params = [];
k = 1;

params(k).beamformer_configs = {...
    'lcmv_eig_filter_0_locs2_3sphere',...
    'lcmv_eig_filter_1_locs2_3sphere',...
    'lcmv_eig_cov_0_locs2_3sphere',...
    'lcmv_eig_cov_1_locs2_3sphere',...
    'rmv_aniso_locs2_3sphere',...
    'lcmv_locs2_3sphere',...
    'lcmv_reg_eig_locs2_3sphere',...
    };
params(k).tag = 'lcmv-eig-cov';
k = k+1;
% LCMV eig cov does pretty bad, probably because of not using pinv

params(k).beamformer_configs = {...
    'lcmv_locs2_3sphere',...
    'lcmv_nopinv_locs2_3sphere',...
    'lcmv_reg_eig_locs2_3sphere',...
    'lcmv_nopinv_reg_eig_locs2_3sphere',...
    };
params(k).tag = 'lcmv-pinv';
k = k+1;
% LCMV no difference in pinv, R is full rank and no where near machine
% epsilon

params(k).beamformer_configs = {...
    'lcmv_eig_cov_0_locs2_3sphere',...
    'lcmv_eig_cov_1_locs2_3sphere',...
    'lcmv_nopinv_eig_cov_0_locs2_3sphere',...
    'lcmv_nopinv_eig_cov_1_locs2_3sphere',...
    };
params(k).tag = 'lcmv-pinv-eig-cov';
k = k+1;
% LCMV pinv performace much better for eig cov

params(k).beamformer_configs = {...
    'lcmv_eig_filter_0_locs2_3sphere',...
    'lcmv_eig_filter_1_locs2_3sphere',...
    'lcmv_nopinv_eig_filter_0_locs2_3sphere',...
    'lcmv_nopinv_eig_filter_1_locs2_3sphere',...
    };
params(k).tag = 'lcmv-pinv-eig-filter';
k = k+1;
% no difference using pinv

for i=1:length(params)
    data_set = SimDataSetEEG(...
        'sim_data_bem_1_100t_1000s',...
        'mult_cort_src_17_lag40',...
        0,...
        'iter',1);
    
    plot_metric_output_vs_input_group(...
        data_set,...
        params(i).beamformer_configs,...
        295,...
        'savetag',params(i).tag,...
        'matched',false,...
        'metricx','snr-input',...
        'metricy','sinr-beamformer-output',...
        'snrs',-20:10:20,...
        'force',force...
        );
    
    plot_metric_output_vs_input_group(...
        data_set,...
        params(i).beamformer_configs,...
        400,...
        'savetag',params(i).tag,...
        'matched',false,...
        'metricx','snr-input',...
        'metricy','isnr-beamformer-output',...
        'snrs',-20:10:20,...
        'force',force...
        );
end
