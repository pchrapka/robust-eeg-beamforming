%% run_all_paper

%% Open the parallel pipeline
% set up parallel execution
lumberjack.parfor_setup();

do_time = false;
do_plots = false;
force = false;

snr_step = 5;
% snr_range = -10:snr_step:60;
snr_range = -10:snr_step:40;

snr_eeg = 10;
snr_power = 20;
snr_beampattern = 20;

flag_expA = false;
flag_expA1 = true;

%% Low res simulations for Output SINR vs Input SNR
% Spatial correlation of 0.5

k=1;
params = [];

%mult src 17 - Spatial correlation of 0.5
% 250 samples
params(k).sim_file = 'sim_data_bem_1_100t_250s_keeptrials_snrpertrial';
params(k).source_file = 'src_param_mult_cortical_source_17_lag40';
params(k).source_name = 'mult_cort_src_17_lag40';
k = k+1;

% %mult src 18 - Spatial correlation of 0
% % 250 samples
% params(k).sim_file = 'sim_data_bem_1_100t_250s_keeptrials_snrpertrial';
% params(k).source_file = 'src_param_mult_cortical_source_18_lag40';
% params(k).source_name = 'mult_cort_src_18_lag40';
% k = k+1;


for i=1:length(params)
    % ensemble average covariance
    if do_time
        run_sim_vars_bem_mult_paper_locs2(...
            params(i).sim_file, params(i).source_file, params(i).source_name,...
            'snrs',snr_range,...
            'cov_type','time',...
            'hmconfigs',{'matched','mismatched'});
        
        if do_plots
            plot_sinr_mult_config_paper(...
                params(i).sim_file, params(i).source_name,...
                'snrs',snr_range,...
                'datatag','locs2_covtime',...
                'force',force,...
                'PlotGroups',{'matched-paper','mismatched-paper'});
        end
        
%         % perturbed
%         run_sim_vars_bem_mult_paper_locs2(...
%             params(i).sim_file, params(i).source_file, params(i).source_name,...
%             'snrs',snr_range,...
%             'cov_type','time',...
%             'hmconfigs',{'mismatched'},...
%             'perturb','perturb0.10');
%         
%         if do_plots
%             plot_sinr_mult_config_paper(...
%                 params(i).sim_file, params(i).source_name,...
%                 'snrs',snr_range,...
%                 'force',force,...
%                 'datatag','locs2_covtime_perturb0.10',...
%                 'PlotGroups',{'mismatched-paper-perturbed'});
%         end
    end
    
        
    if do_plots
        plot_eeg(...
            params(i).sim_file, params(i).source_name,...
            snr_eeg,'samples',[100 180]);
    end
    
    % single trial covariance
    
    if flag_expA
        % scenario A
        % use all samples to compute covariance
        run_sim_vars_bem_mult_paper_locs2(...
            params(i).sim_file, params(i).source_file, params(i).source_name,...
            'snrs',snr_range,...
            'cov_type','trial',...
            'cov_samples',[1:250],...
            'hmconfigs',{'matched','mismatched'}...
            );
        
        if do_plots
            plot_sinr_mult_config_paper(...
                params(i).sim_file, params(i).source_name,...
                'snrs',snr_range,...
                'onaverage',false,...
                'trial_idx',1:100,...
                'force',force,...
                'datatag','locs2_covtrial_s1-250',...
                ...'PlotGroups',{'matched-paper','mismatched-paper','matched-eig','mismatched-eig'}...
                'PlotGroups',{'matched-paper','mismatched-paper'}...
                );
        end
    end
    
    if flag_expA1
        % scenario A.1
        % mismatched head model, aniso with random error, with only one SNR value
        run_sim_vars_bem_mult_paper_locs2(...
            params(i).sim_file, params(i).source_file, params(i).source_name,...
            'snrs',snr_power,...
            'cov_type','trial',...
            'cov_samples',[1:250],...
            'hmconfigs',{'mismatched'},...
            'perturb','aniso',...
            'niterations',100 ...
            );
    
    % TODO below
%     if do_plots
%         plot_sinr_mult_config_paper(...
%             params(i).sim_file, params(i).source_name,...
%             'snrs',snr_power,...
%             'onaverage',false,...
%             'trial_idx',1:100,...
%             'force',force,...
%             'datatag','locs2_covtrial_s1-250',...
%             'PlotGroups',{'mismatched-paper-aniso-perturbed'}...
%             );
%     end
    end
    
    
%     % perturbed
%     run_sim_vars_bem_mult_paper_locs2(...
%         params(i).sim_file, params(i).source_file, params(i).source_name,...
%         'snrs',snr_range,...
%         'cov_type','trial',...
%         'cov_samples',[1:250],...
%         'hmconfigs',{'mismatched'},...
%         'perturb','perturb0.10');
%     
%     if do_plots
%         plot_sinr_mult_config_paper(...
%             params(i).sim_file, params(i).source_name,...
%             'snrs',snr_range,...
%             'onaverage',false,...
%             'trial_idx',1:100,...
%             'force',force,...
%             'datatag','locs2_covtrial_s1-250_perturb0.10',...
%             'PlotGroups',{'mismatched-paper-perturbed'});
%     end
    
%     % scenario B
%     % use a subset of samples to compute covariance
%     run_sim_vars_bem_mult_paper_locs2(...
%         params(i).sim_file, params(i).source_file, params(i).source_name,...
%         'snrs',snr_range,...
%         'cov_type','trial',...
%         'cov_samples',[115:165],...
%         'hmconfigs',{'matched','mismatched'}...
%         );
%     
%     if do_plots
%         plot_sinr_mult_config_paper(...
%             params(i).sim_file, params(i).source_name,...
%             'snrs',snr_range,...
%             'onaverage',false,...
%             'trial_idx',1:100,...
%             'data_idx',115:165,...
%             'force',force,...
%             'datatag','locs2_covtrial_s115-165',...
%             ...'PlotGroups',{'matched-paper','mismatched-paper','matched-eig','mismatched-eig'}...
%             'PlotGroups',{'matched-paper','mismatched-paper'}...
%             );
%     end
%     
% %     run_sim_vars_bem_mult_paper_locs2(...
% %         params(i).sim_file, params(i).source_file, params(i).source_name,...
% %         'snrs',snr_range,...
% %         'cov_type','trial',...
% %         'cov_samples',[115:165],...
% %         'hmconfigs',{'mismatched'},...
% %         'perturb','perturb0.10');
% %     
% %     plot_sinr_mult_config_paper(...
% %         params(i).sim_file, params(i).source_name,...
% %         'snrs',snr_range,...
% %         'onaverage',false,...
% %         'trial_idx',1:100,...
% %         'force',force,...
% %         'datatag','locs2_covtrial_s115-165_perturb0.10',...
% %         'PlotGroups',{'mismatched-paper-perturbed'});
    
    
end

%% HD 2 sources
% beampattern and sinr

sim_file = 'sim_data_bemhd_1_100t_250s_keeptrials_snrpertrial';
source_file = 'src_param_mult_cortical_source_17hd_lag40';
source_name = 'mult_cort_src_17hd_lag40';

% beampattern and sinr requires only 2 locs
run_sim_vars_bemhd_paper(...
    sim_file, source_file, source_name,...
    'config','mult-paper',...
    'locs',[5440,13841],...
    'snrs',snr_beampattern,...
    'cov_type','trial',...
    'cov_samples',[1:250],...
    'hmconfigs',{'matched','mismatched'});

if do_plots
    plot_beampattern_multhd_config_paper(...
        sim_file, source_name,...
        'datatag','locs2_covtrial_s1-250',...
        'PlotGroups',{'matched-beampattern','mismatched-beampattern'},...
        'snr',snr_beampattern);
end

% run_sim_vars_bemhd_paper(...
%     sim_file, source_file, source_name,...
%     'config','mult-paper',...
%     'locs',[5440,13841],...
%     'snrs',snr_beampattern,...
%     'cov_type','trial',...
%     'cov_samples',[1:250],...
%     'perturb','perturb0.10',...
%     'hmconfigs',{'mismatched'});
% 
% if do_plots
% plot_beampattern_multhd_config_paper(...
%     sim_file, source_name,...
%     'datatag','locs2_covtrial_s1-250_perturb0.10',...
%     'PlotGroups',{'mismatched-beampattern-perturbed'},...
%     'snr',snr_beampattern);
% end

%% HD 2 sources - power surface plots
% NOTE These take a while

sim_file = 'sim_data_bemhd_1_100t_250s_keeptrials_snrpertrial';
source_file = 'src_param_mult_cortical_source_17hd_lag40';
source_name = 'mult_cort_src_17hd_lag40';

% NOTE the power is the average of the beamformer output power over all
% trials

% beampattern and sinr requires only 2 locs
run_sim_vars_bemhd_paper(...
    sim_file, source_file, source_name,...
    'config','mult-paper',...
    'locs','all',...
    'snrs',snr_power,...
    'cov_type','trial',...
    'cov_samples',[1:250],...
    'hmconfigs',{'matched','mismatched'});

if do_plots
    plot_power_surface_bemhd_config_paper(...
        sim_file,source_name,...
        'datatag','locsall_covtrial_s1-250',...
        'PlotGroups',{'matched-power','mismatched-power'},...
        'snr',snr_power);
end

% run_sim_vars_bemhd_paper(...
%     sim_file, source_file, source_name,...
%     'config','mult-paper',...
%     'locs','all',...
%     'snrs',snr_power,...
%     'cov_type','trial',...
%     'cov_samples',[1:250],...
%     'perturb','perturb0.10',...
%     'hmconfigs',{'mismatched'});

% if do_plots
% plot_power_surface_bemhd_config_paper(...
%     sim_file,source_name,...
%     'datatag','locsall_covtrial_s1-250_perturb0.10',...
%     'PlotGroups',{'mismatched-power-perturbed'},...
%     'snr',snr_power);
% end



