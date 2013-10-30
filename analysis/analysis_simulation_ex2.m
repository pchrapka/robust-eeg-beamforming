%% analysis_simluation_ex2.m
% Analyzes data from simulation_ex2.m
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

%% mult_cort_src
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cfg.sim_name = 'sim_data_1';
cfg.source_name = 'mult_cort_src';
cfg.exp_name = '';

% cfg.exp_name = 'ex2_snr';
% cfg.file_in = ['..' filesep 'output' filesep...
%     'sim_data_1_mult_cort_src_ex2_snr.mat'];
% analysis_plot_data(cfg);
%
% cfg.file_in = ['..' filesep 'output' filesep...
%     'sim_data_1_mult_cort_src_ex2_epsilon.mat'];
% analysis_plot_data(cfg);
% 
% cfg.sim_name = 'sim_data_1';
% cfg.source_name = 'mult_cort_src_sine';
% cfg.exp_name = 'ex2_snr';
% cfg.file_in = ['..' filesep 'output' filesep...
%     'sim_data_1_mult_cort_src_sine_ex2_snr.mat'];
% analysis_plot_data(cfg);
%
cfg.file_in = ['..' filesep 'output' filesep...
    'sim_data_1_mult_cort_src_ex2_snr_eps_many.mat'];
analysis_plot_data(cfg);

%% mult_cort_src_2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cfg.sim_name = 'sim_data_1';
cfg.source_name = 'mult_cort_src_2';

% cfg.exp_name = '';
% cfg.file_in = ['..' filesep 'output' filesep...
%     'sim_data_1_mult_cort_src_2_ex2_snr_eps_10.mat'];
% analysis_plot_data(cfg);
% 
% cfg.file_in = ['..' filesep 'output' filesep...
%     'sim_data_1_mult_cort_src_2_ex2_snr_eps_200.mat'];
% analysis_plot_data(cfg);
% 
% cfg.file_in = ['..' filesep 'output' filesep...
%     'sim_data_1_mult_cort_src_2_ex2_snr_eps_400.mat'];
% analysis_plot_data(cfg);
% 
% cfg.file_in = ['..' filesep 'output' filesep...
%     'sim_data_1_mult_cort_src_2_ex2_epsilon_0_800_snr-10.mat'];
% analysis_plot_data(cfg);
% 
% cfg.file_in = ['..' filesep 'output' filesep...
%     'sim_data_1_mult_cort_src_2_ex2_epsilon_0_800_snr10.mat'];
% analysis_plot_data(cfg);
% 
% cfg.file_in = ['..' filesep 'output' filesep...
%     'sim_data_1_mult_cort_src_2_ex2_epsilon_0_800_snr20.mat'];
% analysis_plot_data(cfg);

cfg.file_in = ['..' filesep 'output' filesep...
    'sim_data_1_mult_cort_src_2_ex2_snr_eps_many.mat'];
analysis_plot_data(cfg);

%% mult_cort_src_3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cfg.sim_name = 'sim_data_1';
cfg.source_name = 'mult_cort_src_3';
cfg.exp_name = '';

% cfg.file_in = ['..' filesep 'output' filesep...
%     'sim_data_1_mult_cort_src_3_ex2_snr_eps_10.mat'];
% analysis_plot_data(cfg);
% 
% cfg.file_in = ['..' filesep 'output' filesep...
%     'sim_data_1_mult_cort_src_3_ex2_snr_eps_200.mat'];
% analysis_plot_data(cfg);
% 
% cfg.file_in = ['..' filesep 'output' filesep...
%     'sim_data_1_mult_cort_src_3_ex2_snr_eps_400.mat'];
% analysis_plot_data(cfg);
% 
% cfg.file_in = ['..' filesep 'output' filesep...
%     'sim_data_1_mult_cort_src_3_ex2_epsilon_0_800_snr-10.mat'];
% analysis_plot_data(cfg);
% 
% cfg.file_in = ['..' filesep 'output' filesep...
%     'sim_data_1_mult_cort_src_3_ex2_epsilon_0_800_snr10.mat'];
% analysis_plot_data(cfg);
% 
% cfg.file_in = ['..' filesep 'output' filesep...
%     'sim_data_1_mult_cort_src_3_ex2_epsilon_0_800_snr20.mat'];
% analysis_plot_data(cfg);

cfg.file_in = ['..' filesep 'output' filesep...
    'sim_data_1_mult_cort_src_3_ex2_snr_eps_many.mat'];
analysis_plot_data(cfg);