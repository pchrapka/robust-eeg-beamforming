%% power_surface_mult17hd_lag40

force = true;

%% Compute sinr
params = [];
k = 1;

params(k).beamformer_configs = {...
    ...'rmv_epsilon_10',...
    'rmv_epsilon_20',...
    ...'rmv_epsilon_30',...
    ...'rmv_epsilon_40',...
    ...'rmv_epsilon_50',...
    'rmv_eig_pre_cov_0_epsilon_20',...
    'rmv_eig_pre_cov_1_epsilon_20',...
    'lcmv',...
    'lcmv_eig_cov_0',...
    'lcmv_eig_cov_1',...
    'lcmv_reg_eig'
    };
% params(k).tag = '-paper';
% params(k).matched = true;
k = k+1;

params(k).beamformer_configs = {...
    ...'rmv_epsilon_100_3sphere',...
    'rmv_epsilon_150_3sphere',...
    ...'rmv_epsilon_200_3sphere',...
    'rmv_eig_pre_cov_0_epsilon_150_3sphere',...
    'rmv_eig_pre_cov_1_epsilon_150_3sphere',...
    'rmv_aniso_eig_pre_cov_1_3sphere',...
    'rmv_aniso_3sphere',...
    'lcmv_3sphere',...
    'lcmv_eig_cov_0_3sphere',...
    'lcmv_eig_cov_1_3sphere',...
    'lcmv_reg_eig_3sphere'
    };
% params(k).tag = '-paper';
% params(k).matched = false;
k = k+1;

for i=1:length(params)
    data_set = SimDataSetEEG(...
        'sim_data_bemhd_1_100t',...
        'mult_cort_src_17hd_lag40',...
        0,...
        'iter',1);
    
    plot_power_surface(...
        data_set,...
        params(i).beamformer_configs,...
        'source_idx',5440,...
        'int_idx',13841,...
        'mode','average',...
        'force',force...
        );
end
