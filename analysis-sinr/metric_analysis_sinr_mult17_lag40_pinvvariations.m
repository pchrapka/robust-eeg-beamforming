%% metric_analysis_sinr_mult17_lag40_pinvvariations
force = true;

%% Compute sinr
params = [];
k = 1;

params(k).beamformer_configs = {...
    'lcmv_eig_filter_0_3sphere',...
    'lcmv_eig_filter_1_3sphere',...
    'lcmv_eig_cov_0_3sphere',...
    'lcmv_eig_cov_1_3sphere',...
    'rmv_aniso_3sphere',...
    'lcmv_3sphere',...
    'lcmv_reg_eig_3sphere'
    };
params(k).tag = 'lcmv-eig-cov';
k = k+1;
% LCMV eig cov does pretty bad, probably because of not using pinv

params(k).beamformer_configs = {...
    'lcmv_3sphere',...
    'lcmv_pinv_3sphere',...
    'lcmv_reg_eig_3sphere',...
    'lcmv_pinv_reg_eig_3sphere',...
    };
params(k).tag = 'lcmv-pinv';
k = k+1;
% LCMV no difference in pinv, R is full rank and no where near machine
% epsilon

params(k).beamformer_configs = {...
    'lcmv_eig_cov_0_3sphere',...
    'lcmv_eig_cov_1_3sphere',...
    'lcmv_pinv_eig_cov_0_3sphere',...
    'lcmv_pinv_eig_cov_1_3sphere',...
    };
params(k).tag = 'lcmv-pinv-eig-cov';
k = k+1;
% LCMV pinv performace much better for eig cov

params(k).beamformer_configs = {...
    'lcmv_eig_filter_0_3sphere',...
    'lcmv_eig_filter_1_3sphere',...
    'lcmv_pinv_eig_filter_0_3sphere',...
    'lcmv_pinv_eig_filter_1_3sphere',...
    };
params(k).tag = 'lcmv-pinv-eig-filter';
k = k+1;
% no difference using pinv

for i=1:length(params)
    plot_sinr_vs_snr_group(...
        'sim_data_bem_1_100t',...
        'mult_cort_src_17_lag40',...
        params(i).beamformer_configs,...
        295,...
        'savetag',params(i).tag,...
        'matched',false,...
        'flip',false,...
        'iteration',1,...
        'snrs',-20:10:20,...
        'force',force...
        );
    
    plot_sinr_vs_snr_group(...
        'sim_data_bem_1_100t',...
        'mult_cort_src_17_lag40',...
        params(i).beamformer_configs,...
        400,...
        'savetag',params(i).tag,...
        'matched',false,...
        'flip',true,...
        'iteration',1,...
        'snrs',-20:10:20,...
        'force',force...
        );
end