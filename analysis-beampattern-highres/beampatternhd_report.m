%% beampattern_report

%% Generate data
% run_sim_vars_bemhd_mult17hd

snr = 0;

%% Set up beamformer configs
params = [];
k = 1;

%% ==== MATCHED LEADFIELD ====
% Set up beamformer data sets to process
params(k).beam_cfgs = {...
    'rmv_epsilon_20',...
    'lcmv',...
    'lcmv_eig_cov_0',...
    'lcmv_eig_cov_1',...
    'lcmv_reg_eig'...
    };
params(k).matched = true;
params(k).snr = snr;
k = k+1;

%% ==== MISMATCHED LEADFIELD ====
% Set up beamformer data sets to process
params(k).beam_cfgs = {...
    'rmv_epsilon_100_3sphere',...
    'rmv_epsilon_150_3sphere',...
    'rmv_epsilon_175_3sphere',...
    'rmv_epsilon_200_3sphere',...
    'rmv_aniso_3sphere',...
    'rmv_aniso_eig_pre_cov_0_3sphere',...
    'rmv_aniso_eig_pre_cov_1_3sphere',...
    'lcmv_3sphere',...
    'lcmv_eig_cov_0_3sphere',...
    'lcmv_eig_cov_1_3sphere',...
    'lcmv_reg_eig_3sphere',...
    };
params(k).matched = false;
params(k).snr = snr;
k = k+1;

for k=1:length(params)
    
    source_idx = 5440;
    int_idx = 13841;
    
    % Set up simulation info
    data_set = SimDataSetEEG(...
        'sim_data_bemhd_1_100t_1000s',...
        'mult_cort_src_17hd',...
        params(k).snr,...
        'iter',1);
    
    %% Compute beampatterns
    
    %matched = true;
    %cfg = get_beampattern_config('highres',params(k).matched, snr);
    
    % Compute the beampattern
    outputfiles = compute_beampattern(...
        data_set,...
        params(k).beam_cfgs,...
        source_idx,...
        'int_idx',int_idx);
    
    %% Plot data
    
    scales = {...
        'relative',...
        'relative-dist',...
        ...'mad',...
        'globalabsolute'...
        'globalabsolute-dist'...
        };
    
    for j=1:length(scales)
        args = get_view_beampattern_args('default','beampattern',scales{j});
        view_beampattern(outputfiles,'source_idx',source_idx,args{:});
    end
    
    for j=1:length(scales)
        args = get_view_beampattern_args('default','beampattern3d',scales{j});
        view_beampattern(outputfiles,'source_idx',source_idx,args{:});
    end
    
    params(k).outputfiles = outputfiles;
    
end

%% Plot data - matched, mismatched

outputfiles = [params(1).outputfiles params(2).outputfiles];
args = get_view_beampattern_args('default','mmabsolute-dist');
view_beampattern(outputfiles,'source_idx',cfg_mismatched.source_idx,args{:});

%% Plot beampattern diff - matched
% cfg = [];
% cfg.beamcfga = 'rmv_epsilon_20';
% cfg.beamcfgb = 'lcmv';
% plot_beampatternhd_diff_mult17hd(cfg);
%
% cfg = [];
% cfg.beamcfga = 'rmv_epsilon_30';
% cfg.beamcfgb = 'rmv_epsilon_20';
% plot_beampatternhd_diff_mult17hd(cfg);
% close all

