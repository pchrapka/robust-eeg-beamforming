%% metric_analysis_sinr_mult17_lag40_eigvariations

force = true;

%% Compute sinr
params = [];
k = 1;

params(k).beamformer_configs = {...
    'rmv_epsilon_50_3sphere',...
    'rmv_epsilon_100_3sphere',...
    'rmv_epsilon_150_3sphere',...
    'rmv_epsilon_200_3sphere',...
    'rmv_aniso_3sphere',...
    'lcmv_3sphere',...
    'lcmv_eig_filter_0_3sphere',...
    'lcmv_eig_filter_1_3sphere',...
    'lcmv_reg_eig_3sphere'
    };
params(k).tag = 'iso';
k = k+1;

% params(k).beamformer_configs = {...
%     'rmv_eig_post_0_epsilon_50_3sphere',...
%     'rmv_eig_post_0_epsilon_100_3sphere',...
%     'rmv_eig_post_0_epsilon_150_3sphere',...
%     'rmv_eig_post_0_epsilon_200_3sphere',...
%     'rmv_aniso_eig_post_0_3sphere',...
%     'rmv_aniso_3sphere',...
%     'lcmv_3sphere',...
%     'lcmv_eig_filter_0_3sphere',...
%     'lcmv_eig_filter_1_3sphere',...
%     'lcmv_reg_eig_3sphere'
%     };
% params(k).tag = 'eig-post-0';
% k = k+1;
% RMVB eig post 0 has same performance as lcmv eig 0

params(k).beamformer_configs = {...
    'rmv_eig_post_1_epsilon_50_3sphere',...
    'rmv_eig_post_1_epsilon_100_3sphere',...
    'rmv_eig_post_1_epsilon_150_3sphere',...
    'rmv_eig_post_1_epsilon_200_3sphere',...
    'rmv_aniso_eig_post_1_3sphere',...
    'rmv_aniso_3sphere',...
    'lcmv_3sphere',...
    'lcmv_eig_filter_0_3sphere',...
    'lcmv_eig_filter_1_3sphere',...
    'lcmv_reg_eig_3sphere'
    };
params(k).tag = 'eig-post-1';
k = k+1;
% RMVB eig post 1 interesting performance, RMVB aniso eig post outperforms
% by a lot, iso performance decreases as error increases

params(k).beamformer_configs = {...
    'rmv_eig_pre_cov_0_epsilon_1-000000e-04_3sphere',...
    'rmv_eig_pre_cov_0_epsilon_1-000000e-03_3sphere',...
    'rmv_eig_pre_cov_0_epsilon_1-000000e-02_3sphere',...
    'rmv_eig_pre_cov_0_epsilon_1-000000e-01_3sphere',...
    'rmv_eig_pre_cov_0_epsilon_1_3sphere',...
    'rmv_eig_pre_cov_0_epsilon_10_3sphere',...
    'rmv_eig_pre_cov_0_epsilon_100_3sphere',...
    'rmv_aniso_eig_pre_cov_0_3sphere',...
    'rmv_aniso_3sphere',...
    'lcmv_3sphere',...
    'lcmv_eig_filter_0_3sphere',...
    'lcmv_eig_filter_1_3sphere',...
    'lcmv_reg_eig_3sphere'
    };
params(k).tag = 'eig-pre-cov-0';
k = k+1;
% RMVB eig pre cov 0 is pretty bad

params(k).beamformer_configs = {...
    'rmv_eig_pre_cov_1_epsilon_1-000000e-04_3sphere',...
    'rmv_eig_pre_cov_1_epsilon_1-000000e-03_3sphere',...
    'rmv_eig_pre_cov_1_epsilon_1-000000e-02_3sphere',...
    'rmv_eig_pre_cov_1_epsilon_1-000000e-01_3sphere',...
    'rmv_eig_pre_cov_1_epsilon_1_3sphere',...
    'rmv_eig_pre_cov_1_epsilon_10_3sphere',...
    'rmv_eig_pre_cov_1_epsilon_100_3sphere',...
    'rmv_aniso_eig_pre_cov_1_3sphere',...
    'rmv_aniso_3sphere',...
    'lcmv_3sphere',...
    'lcmv_eig_filter_0_3sphere',...
    'lcmv_eig_filter_1_3sphere',...
    'lcmv_reg_eig_3sphere'
    };
params(k).tag = 'eig-pre-cov-1';
k = k+1;
% RMVB eig pre cov 0 is pretty bad

params(k).beamformer_configs = {...
    'rmv_eig_pre_leadfield_0_epsilon_1-000000e-04_3sphere',...
    'rmv_eig_pre_leadfield_0_epsilon_1-000000e-03_3sphere',...
    'rmv_eig_pre_leadfield_0_epsilon_1-000000e-02_3sphere',...
    'rmv_eig_pre_leadfield_0_epsilon_1-000000e-02_3sphere',...
    'rmv_eig_pre_leadfield_0_epsilon_1_3sphere',...
    'rmv_eig_pre_leadfield_0_epsilon_10_3sphere',...
    'rmv_eig_pre_leadfield_0_epsilon_100_3sphere',...
    'rmv_aniso_eig_pre_leadfield_0_3sphere',...
    'rmv_aniso_3sphere',...
    'lcmv_3sphere',...
    'lcmv_eig_filter_0_3sphere',...
    'lcmv_eig_filter_1_3sphere',...
    'lcmv_reg_eig_3sphere'
    };
params(k).tag = 'eig-pre-lf-0';
k = k+1;
% RMVB eig pre leadfield similar to LCMV eig

params(k).beamformer_configs = {...
    'rmv_eig_pre_leadfield_1_epsilon_1-000000e-04_3sphere',...
    'rmv_eig_pre_leadfield_1_epsilon_1-000000e-03_3sphere',...
    'rmv_eig_pre_leadfield_1_epsilon_1-000000e-02_3sphere',...
    'rmv_eig_pre_leadfield_1_epsilon_1-000000e-01_3sphere',...
    'rmv_eig_pre_leadfield_1_epsilon_1_3sphere',...
    'rmv_eig_pre_leadfield_1_epsilon_10_3sphere',...
    'rmv_eig_pre_leadfield_1_epsilon_100_3sphere',...
    'rmv_aniso_eig_pre_leadfield_1_3sphere',...
    'rmv_aniso_3sphere',...
    'lcmv_3sphere',...
    'lcmv_eig_filter_0_3sphere',...
    'lcmv_eig_filter_1_3sphere',...
    'lcmv_reg_eig_3sphere'
    };
params(k).tag = 'eig-pre-lf-1';
k = k+1;
% RMVB eig pre leadfield slightly better than to LCMV eig 0

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

params(k).beamformer_configs = {...
    'lcmv_3sphere',...
    'lcmv_pinv_3sphere',...
    'lcmv_reg_eig_3sphere',...
    'lcmv_pinv_reg_eig_3sphere',...
    };
params(k).tag = 'lcmv-pinv';
k = k+1;

params(k).beamformer_configs = {...
    'lcmv_eig_cov_0_3sphere',...
    'lcmv_eig_cov_1_3sphere',...
    'lcmv_pinv_eig_cov_0_3sphere',...
    'lcmv_pinv_eig_cov_1_3sphere',...
    };
params(k).tag = 'lcmv-pinv-eig-cov';
k = k+1;

params(k).beamformer_configs = {...
    'lcmv_eig_filter_0_3sphere',...
    'lcmv_eig_filter_1_3sphere',...
    'lcmv_pinv_eig_filter_0_3sphere',...
    'lcmv_pinv_eig_filter_1_3sphere',...
    };
params(k).tag = 'lcmv-pinv-eig-filter';
k = k+1;

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