function plot_sinr_mult_config_paper(sim_file,source_name,varargin)

p = inputParser();
addRequired(p,'sim_file',@ischar);
addRequired(p,'source_name',@ischar);
addParameter(p,'matched','both',@(x) any(validatestring(x,{'matched','mismatched','both'})));
addParameter(p,'snrs',-10:5:30,@isvector);
parse(p,sim_file,source_name,varargin{:});

%% Compute sinr
force = true;
params = [];
k = 1;

%% Matched
if isequal(p.Results.matched,'both') || isequal(p.Results.matched,'matched')
    params(k).beamformer_configs = {...
        'rmv_epsilon_20_locs2',...
        'lcmv_locs2',...
        'lcmv_eig_cov_1_locs2',...
        'lcmv_reg_eig_locs2',...
        };
    params(k).tag = '-paper';
    params(k).matched = true;
    k = k+1;
    
    params(k).beamformer_configs = {...
        'rmv_epsilon_20_locs2',...
        'rmv_eig_pre_cov_0_epsilon_20_locs2',...
        'rmv_eig_pre_cov_1_epsilon_20_locs2',...
        'rmv_eig_post_1_epsilon_20_locs2',...
        'lcmv_locs2',...
        'lcmv_eig_cov_0_locs2',...
        'lcmv_eig_cov_1_locs2',...
        ...'lcmv_eig_filter_0_locs2',... temp
        ...'lcmv_eig_filter_1_locs2',... temp
        'lcmv_reg_eig_locs2',...
        };
    params(k).tag = '-paper-eig';
    params(k).matched = true;
    k = k+1;
end

%% Mismatched
if isequal(p.Results.matched,'both') || isequal(p.Results.matched,'mismatched')
    params(k).beamformer_configs = {...
        'rmv_epsilon_100_locs2_3sphere',...
        'rmv_epsilon_150_locs2_3sphere',...
        'rmv_epsilon_200_locs2_3sphere',...
        'rmv_aniso_locs2_3sphere',...
        'lcmv_locs2_3sphere',...
        'lcmv_eig_cov_1_locs2_3sphere',...
        'lcmv_reg_eig_locs2_3sphere',...
        };
    params(k).tag = '-paper';
    params(k).matched = false;
    k = k+1;
    
    params(k).beamformer_configs = {...
        'rmv_epsilon_150_locs2_3sphere',...
        'rmv_eig_pre_cov_0_epsilon_150_locs2_3sphere',...
        'rmv_eig_pre_cov_1_epsilon_150_locs2_3sphere',...
        'rmv_eig_post_1_epsilon_150_locs2_3sphere',...
        'rmv_aniso_eig_pre_cov_1_locs2_3sphere',...
        'rmv_aniso_eig_post_1_locs2_3sphere',...
        'rmv_aniso_locs2_3sphere',...
        'lcmv_locs2_3sphere',...
        'lcmv_eig_cov_0_locs2_3sphere',...
        'lcmv_eig_cov_1_locs2_3sphere',...
        ...'lcmv_eig_filter_0_locs2_3sphere',... temp
        ...'lcmv_eig_filter_1_locs2_3sphere',... temp
        'lcmv_reg_eig_locs2_3sphere',...
        };
    params(k).tag = '-paper-eig';
    params(k).matched = false;
    k = k+1;
end

%% Plots
for i=1:length(params)
    data_set = SimDataSetEEG(...
        sim_file,...
        source_name,...
        0,...
        'iter',1);
    
    % signal location, oSINR vs iSNR
    plot_metric_output_vs_input_group(...
        data_set,...
        params(i).beamformer_configs,...
        295,...
        'savetag',params(i).tag,...
        'matched',params(i).matched,...
        'metricx','snr-input',...
        'metricy','sinr-beamformer-output',...
        'snrs',p.Results.snrs,...
        'force',force...
        );
    
    % signal location, oSNR vs iSNR
    plot_metric_output_vs_input_group(...
        data_set,...
        params(i).beamformer_configs,...
        295,...
        'savetag',params(i).tag,...
        'matched',params(i).matched,...
        'metricx','snr-input',...
        'metricy', 'snr-beamformer-output',...
        'snrs',p.Results.snrs,...
        'force',force...
        );
    
    % interference location, oISNR vs iSNR
    plot_metric_output_vs_input_group(...
        data_set,...
        params(i).beamformer_configs,...
        400,...
        'savetag',params(i).tag,...
        'matched',params(i).matched,...
        'metricx','snr-input',...
        'metricy','isnr-beamformer-output',...
        'snrs',p.Results.snrs,...
        'force',force...
        );
end
