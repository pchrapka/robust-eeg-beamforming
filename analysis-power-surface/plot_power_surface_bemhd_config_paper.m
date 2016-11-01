function plot_power_surface_bemhd_config_paper(sim_file,source_name,varargin)

p = inputParser();
addRequired(p,'sim_file',@ischar);
addRequired(p,'source_name',@ischar);
addParameter(p,'matched','both',@(x) any(validatestring(x,{'matched','mismatched','both'})));
addParameter(p,'snr',0,@isnumeric);
addParameter(p,'config','',@ischar);
parse(p,sim_file,source_name,varargin{:});

%% Compute power
force = false;
params = [];
k = 1;

for i=1:length(p.Results.hmconfigs)
    switch p.Results.hmconfigs{i}
        case 'matched'
            switch p.Results.config
                case 'mult-paper'
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
                        'lcmv_eig_filter_1',...
                        'lcmv_reg_eig'
                        };
                case 'single-paper'
                    params(k).beamformer_configs = {...
                        ...'rmv_epsilon_10',...
                        'rmv_epsilon_20',...
                        ...'rmv_epsilon_30',...
                        ...'rmv_epsilon_40',...
                        ...'rmv_epsilon_50',...
                        'rmv_eig_pre_cov_0_epsilon_20',...
                        'lcmv',...
                        'lcmv_eig_cov_0',...
                        'lcmv_reg_eig'...
                        };
                otherwise
                    error('unknown config');
            end
            k = k+1;
        case 'mismatched'
            switch p.Results.config
                case 'mult-paper'
                    params(k).beamformer_configs = {...
                        'rmv_epsilon_100_3sphere',...
                        'rmv_epsilon_150_3sphere',...
                        'rmv_epsilon_175_3sphere',...
                        'rmv_epsilon_200_3sphere',...
                        'rmv_eig_pre_cov_0_epsilon_150_3sphere',...
                        'rmv_eig_pre_cov_1_epsilon_150_3sphere',...
                        'rmv_eig_post_1_epsilon_150_3sphere',...
                        'rmv_aniso_eig_pre_cov_1_3sphere',...
                        'rmv_aniso_eig_post_1_3sphere',...
                        'rmv_aniso_3sphere',...
                        'lcmv_3sphere',...
                        'lcmv_eig_cov_0_3sphere',...
                        'lcmv_eig_cov_1_3sphere',...
                        'lcmv_eig_filter_1_3sphere',...
                        'lcmv_reg_eig_3sphere'
                        };
                case 'single-paper'
                    params(k).beamformer_configs = {...
                        'rmv_epsilon_100_3sphere',...
                        'rmv_epsilon_150_3sphere',...
                        'rmv_epsilon_175_3sphere',...
                        'rmv_epsilon_200_3sphere',...
                        'rmv_eig_pre_cov_0_epsilon_150_3sphere',...
                        'rmv_eig_post_0_epsilon_150_3sphere',...
                        'rmv_aniso_eig_pre_cov_0_3sphere',...
                        'rmv_aniso_eig_post_0_3sphere',...
                        'rmv_aniso_3sphere',...
                        'lcmv_3sphere',...
                        'lcmv_eig_cov_0_3sphere',...
                        'lcmv_reg_eig_3sphere'};
                otherwise
                    error('unknown config');
            end
            k = k+1;
        case 'mismatched_perturbed'
            switch p.Results.config
                case 'mult-paper'
                    params(k).beamformer_configs = {...
                        'rmv_aniso_eig_pre_cov_1_3sphere_perturb0.10',...
                        'rmv_aniso_eig_post_1_3sphere_perturb0.10',...
                        'rmv_aniso_3sphere_perturb0.10',...
                        };
                case 'single-paper'
                    params(k).beamformer_configs = {...
                        'rmv_aniso_eig_pre_cov_0_3sphere_perturb0.10',...
                        'rmv_aniso_eig_post_0_3sphere_perturb0.10',...
                        'rmv_aniso_3sphere_perturb0.10',...
                        };
                otherwise
                    error('unknown config');
            end
    end
end

%% Set vars
eval(sim_file);
samples_avg{1} = 1:sim_cfg.timepoints;
clear sim_cfg;

switch p.Results.config
    case 'mult-paper'
        source_args = {'source_idx',5440,'int_idx',13841};
        samples = [120,160];
        samples_avg{2} = 110:170;
    case 'single-paper'
        source_args = {'source_idx',5440};
        samples = 120;
        samples_avg{2} = 110:130;
    otherwise
        error('unknown config');
end

%% average power
for j=1:length(samples_avg)
    sample = samples_avg{j};
    for i=1:length(params)
        data_set = SimDataSetEEG(...
            sim_file,...
            source_name,...
            p.Results.snr,...
            'iter',1);
        
        plot_power_surface(...
            data_set,...
            params(i).beamformer_configs,...
            sample,...
            source_args{:},...
            'force',force...
            );
    end
end

%% instantaneous power
for j=1:length(samples)
    sample = samples(j);
    for i=1:length(params)
        data_set = SimDataSetEEG(...
            sim_file,...
            source_name,...
            p.Results.snr,...
            'iter',1);
        
        plot_power_surface(...
            data_set,...
            params(i).beamformer_configs,...
            sample,...
            source_args{:},...
            'force',force...
            );
    end
end

end