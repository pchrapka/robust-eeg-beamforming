function plot_sinr_single_config_paper(sim_file,source_name,varargin)

p = inputParser();
addRequired(p,'sim_file',@ischar);
addRequired(p,'source_name',@ischar);
addParameter(p,'matched','both',@(x) any(validatestring(x,{'matched','mismatched','both'})));
parse(p,sim_file,source_name,varargin{:});

force = true;
params = [];
k = 1;

%% Matched
if isequal(p.Results.matched,'both') || isequal(p.Results.matched,'matched')
    params(k).beamformer_configs = {...
        'rmv_epsilon_20_locs1',...
        'rmv_eig_pre_cov_0_epsilon_20_locs1',...
        ...'rmv_eig_post_0_epsilon_20_locs1',... same performance as LCMV eig cov
        'lcmv_locs1',...
        'lcmv_eig_cov_0_locs1',...
        ...'lcmv_eig_filter_0_locs1',... same performance as LCMV eig cov
        'lcmv_reg_eig_locs1',...
        };
    params(k).tag = '-paper';
    params(k).matched = true;
    k = k+1;
end

%% Mismatched
if isequal(p.Results.matched,'both') || isequal(p.Results.matched,'mismatched')
    params(k).beamformer_configs = {...
        'rmv_epsilon_100_locs1_3sphere',...
        'rmv_epsilon_150_locs1_3sphere',...
        'rmv_epsilon_200_locs1_3sphere',...
        ...'rmv_eig_pre_cov_0_epsilon_100_locs1_3sphere',...
        'rmv_eig_pre_cov_0_epsilon_150_locs1_3sphere',...
        ...'rmv_eig_pre_cov_0_epsilon_200_locs1_3sphere',...
        ...'rmv_eig_post_0_epsilon_150_locs1_3sphere',...same performance as LCMV eig cov
        'rmv_aniso_eig_pre_cov_0_locs1_3sphere',...
        'rmv_aniso_locs1_3sphere',...
        'lcmv_locs1_3sphere',...
        'lcmv_eig_cov_0_locs1_3sphere',...
        ...'lcmv_eig_filter_0_locs1_3sphere',... same performance as LCMV eig cov
        'lcmv_reg_eig_locs1_3sphere',...
        };
    params(k).tag = '-paper';
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
    
    % signal location, oSNR vs iSNR
    plot_metric_output_vs_input_group(...
        data_set,...
        params(i).beamformer_configs,...
        295,...
        'savetag',params(i).tag,...
        'matched',params(i).matched,...
        'metricx','snr-input',...
        'metricy', 'snr-beamformer-output',...
        'snrs',-10:5:30,...
        'force',force...
        );
end

end
