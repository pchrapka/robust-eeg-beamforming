%% beampattern_report

%% Generate data
% run_sim_vars_bemhd_mult17hd

snrs = [0, -20];

for i=1:length(snrs)
    snr = snrs(i);
    
    %% Compute beampatterns - matched
    
    matched = true;
    cfg_matched = get_beampattern_config('highres',matched, snr);
    
    % Compute the beampattern
    outputfiles_matched = compute_beampattern(...
        cfg_matched.data_set,...
        cfg_matched.beam_cfgs,...
        cfg_matched.source_idx,...
        cfg_matched.args{:});
    
    %% Plot data
    
    scales = {...
        'relative',...
        ...'relative-dist',...
        ...'mad',...
        'globalabsolute'...
        };
    
    for j=1:length(scales)
        args = get_view_beampattern_args('default',scales{j});
        view_beampattern(outputfiles_matched,'source_idx',cfg_matched.source_idx,args{:});
    end
    
    % plot_beampatternhd_mult17hd_relative(cfg_matched);
    % % plot_beampatternhd_mult17hd_relativedist(cfg_matched);
    % % plot_beampatternhd_mult17hd_mad(cfg_matched);
    % plot_beampatternhd_mult17hd_global(cfg_matched);
    
    %% Compute beampatterns - mismatched
    
    matched = false;
    cfg_mismatched = get_beampattern_config('highres',matched, snr);
    
    % Compute the beampattern
    outputfiles_mismatched = compute_beampattern(...
        cfg_mismatched.data_set,...
        cfg_mismatched.beam_cfgs,...
        cfg_mismatched.source_idx,...
        cfg_mismatched.args{:});
    
    %% Plot data
    
    scales = {...
        'relative',...
        'relative-dist',...
        ...'mad',...
        'globalabsolute'...
        'globalabsolute-dist'...
        };
    
    for j=1:length(scales)
        args = get_view_beampattern_args('default',scales{j});
        view_beampattern(outputfiles_mismatched,'source_idx',cfg_mismatched.source_idx,args{:});
    end
    
    % plot_beampatternhd_mult17hd_relative(cfg_mismatched);
    % plot_beampatternhd_mult17hd_relativedist(cfg_mismatched);
    % % plot_beampatternhd_mult17hd_mad(cfg_mismatched);
    % plot_beampatternhd_mult17hd_global(cfg_mismatched);
    % plot_beampatternhd_mult17hd_globaldist(cfg_mismatched);
    
    %% Plot data - matched, mismatched
    
    outputfiles = [outputfiles_matched outputfiles_mismatched];
    args = get_view_beampattern_args('default','mmabsolute-dist');
    view_beampattern(outputfiles,'source_idx',cfg_mismatched.source_idx,args{:});
    % plot_beampatternhd_mult17hd_matched_vs_mismatched(cfg);
    
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
    
end
