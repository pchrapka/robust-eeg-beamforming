function metric_analysis_sinr_mult(sim_name,source_name)

force = true;

%% Compute sinr
params = [];
k = 1;

% FIXME pre cov or pre leadfield??
params(k).beamformer_configs = {...
    'rmv_epsilon_20',...
    'rmv_eig_pre_cov_0_epsilon_20',...
    'rmv_eig_pre_cov_1_epsilon_20',...
    'lcmv',...
    'lcmv_eig_cov_0',...
    'lcmv_eig_cov_1',...
    ...'lcmv_eig_filter_0',...
    ...'lcmv_eig_filter_1',...
    'lcmv_reg_eig'
    };
params(k).tag = '-final';
params(k).matched = true;
k = k+1;

% comparison of lcmv eigs in matched scenario
params(k).beamformer_configs = {...
    'rmv_epsilon_20',...
    'lcmv',...
    'lcmv_eig_leadfield_1',...
    'lcmv_eig_cov_1',...
    'lcmv_eig_filter_1',...
    'lcmv_eig_cov_lf_1',...
    'lcmv_reg_eig'
    };
params(k).tag = '-lcmv';
params(k).matched = true;
k = k+1;

% FIXME pre cov or pre leadfield??
params(k).beamformer_configs = {...
    ...'rmv_epsilon_100_3sphere',...
    ...'rmv_eig_pre_cov_0_epsilon_100_3sphere',...
    ...'rmv_eig_pre_cov_1_epsilon_100_3sphere',...
    'rmv_epsilon_150_3sphere',...
    'rmv_eig_pre_leadfield_0_epsilon_150_3sphere',...
    'rmv_eig_pre_leadfield_1_epsilon_150_3sphere',...
    'rmv_eig_pre_cov_0_epsilon_150_3sphere',...
    'rmv_eig_pre_cov_1_epsilon_150_3sphere',...
    ...'rmv_epsilon_200_3sphere',...
    ...'rmv_eig_pre_cov_0_epsilon_200_3sphere',...
    ...'rmv_eig_pre_cov_1_epsilon_200_3sphere',...
    'rmv_aniso_eig_pre_leadfield_1_3sphere',...
    'rmv_aniso_eig_pre_cov_1_3sphere',...
    'rmv_aniso_3sphere',...
    'lcmv_3sphere',...
    'lcmv_eig_cov_0_3sphere',...
    'lcmv_eig_cov_1_3sphere',...
    'lcmv_reg_eig_3sphere'
    };
params(k).tag = '-final';
params(k).matched = false;
k = k+1;

params(k).beamformer_configs = {...
    'rmv_epsilon_150_3sphere',...
    'rmv_aniso_3sphere',...
    'lcmv_3sphere',...
    'lcmv_eig_cov_0_3sphere',...
    'lcmv_eig_cov_1_3sphere',...
    'lcmv_eig_leadfield_0_3sphere',...
    'lcmv_eig_leadfield_1_3sphere',...
    'lcmv_eig_filter_0_3sphere',...
    'lcmv_eig_filter_1_3sphere',...
    'lcmv_eig_cov_lf_0_3sphere',...
    'lcmv_eig_cov_lf_1_3sphere',...
    'lcmv_reg_eig_3sphere'
    };
params(k).tag = '-lcmv';
params(k).matched = false;
k = k+1;

% params(k).beamformer_configs = {...
%     'rmv_epsilon_100_3sphere',...
%     'rmv_epsilon_150_3sphere',...
%     'rmv_epsilon_200_3sphere',...
%     'rmv_eig_pre_cov_0_epsilon_100_3sphere',...
%     'rmv_eig_pre_cov_0_epsilon_150_3sphere',...
%     'rmv_eig_pre_cov_0_epsilon_200_3sphere',...
%     'rmv_eig_pre_cov_1_epsilon_100_3sphere',...
%     'rmv_eig_pre_cov_1_epsilon_150_3sphere',...
%     'rmv_eig_pre_cov_1_epsilon_200_3sphere',...
%     };
% params(k).tag = '-eps-variations';
% params(k).matched = false;
% k = k+1;

for i=1:length(params)
    plot_sinr_vs_snr_group(...
        sim_name,...
        source_name,...
        params(i).beamformer_configs,...
        295,...
        'savetag',params(i).tag,...
        'matched',params(i).matched,...
        'flip',false,...
        'iteration',1,...
        'snrs',-20:5:20,...
        'force',force...
        );
    
    plot_sinr_vs_snr_group(...
        sim_name,...
        source_name,...
        params(i).beamformer_configs,...
        400,...
        'savetag',params(i).tag,...
        'matched',params(i).matched,...
        'flip',true,...
        'iteration',1,...
        'snrs',-20:5:20,...
        'force',force...
        );
end
end