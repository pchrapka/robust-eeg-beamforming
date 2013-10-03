%% analysis_simluation_ex1.m
% Analyzes data from simulation_ex1.m
clc;
clear all;
close all;

% Create the directory if it doesn't exist
out_dir = 'output';
if ~exist(out_dir, 'dir')
    mkdir(out_dir);
end

%% Set up some defaults
set(0,'DefaultAxesColorOrder',[0,0,0]) % black and white
    
%% Create plots

% cfg.sim_name = 'sim_data_1';
% cfg.source_name = 'mult_cort_src';
% cfg.exp_name = 'ex1_snr';
% cfg.file_in = ['..' filesep 'output' filesep...
%     cfg.sim_name '_' cfg.source_name '_' cfg.exp_name '.mat'];
% analysis_plot_data(cfg);
% 
% cfg.sim_name = 'sim_data_1';
% cfg.source_name = 'mult_cort_src';
% cfg.exp_name = 'ex1_epsilon';
% cfg.file_in = ['..' filesep 'output' filesep...
%     cfg.sim_name '_' cfg.source_name '_' cfg.exp_name '.mat'];
% analysis_plot_data(cfg);
% 
% cfg.sim_name = 'sim_data_1';
% cfg.source_name = 'mult_cort_src';
% cfg.exp_name = 'ex1_epsilon_eig';
% cfg.file_in = ['..' filesep 'output' filesep...
%     'sim_data_1_lcmv_eig_mult_cort_src_ex1_snr.mat'];
% analysis_plot_data(cfg);

cfg.sim_name = 'sim_data_1';
cfg.source_name = 'mult_cort_src';
cfg.exp_name = '';
cfg.file_in = ['..' filesep 'output' filesep...
    'sim_data_1_mult_cort_src_ex1_snr_eps_200.mat'];
analysis_plot_data(cfg);

cfg.sim_name = 'sim_data_1';
cfg.source_name = 'mult_cort_src';
cfg.exp_name = '';
cfg.file_in = ['..' filesep 'output' filesep...
    'sim_data_1_mult_cort_src_ex1_snr_eps_400.mat'];
analysis_plot_data(cfg);

cfg.sim_name = 'sim_data_1';
cfg.source_name = 'mult_cort_src';
cfg.exp_name = '';
cfg.file_in = ['..' filesep 'output' filesep...
    'sim_data_1_mult_cort_src_ex1_epsilon_0_800_snr-10.mat'];
analysis_plot_data(cfg);

cfg.sim_name = 'sim_data_1';
cfg.source_name = 'mult_cort_src';
cfg.exp_name = '';
cfg.file_in = ['..' filesep 'output' filesep...
    'sim_data_1_mult_cort_src_ex1_epsilon_0_800_snr10.mat'];
analysis_plot_data(cfg);

cfg.sim_name = 'sim_data_1';
cfg.source_name = 'mult_cort_src';
cfg.exp_name = '';
cfg.file_in = ['..' filesep 'output' filesep...
    'sim_data_1_mult_cort_src_ex1_epsilon_0_800_snr20.mat'];
analysis_plot_data(cfg);


