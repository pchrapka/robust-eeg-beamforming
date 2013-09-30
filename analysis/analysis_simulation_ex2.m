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

cfg.sim_name = 'sim_data_1';
cfg.source_name = 'mult_cort_src';
cfg.exp_name = 'ex2_snr';
cfg.file_in = ['..' filesep 'output' filesep...
    'sim_data_1_mult_cort_src_ex2_snr.mat'];
analysis_plot_data(cfg);

cfg.sim_name = 'sim_data_1';
cfg.source_name = 'mult_cort_src';
cfg.exp_name = 'ex2_epsilon';
cfg.file_in = ['..' filesep 'output' filesep...
    'sim_data_1_mult_cort_src_ex2_epsilon.mat'];
analysis_plot_data(cfg);

cfg.sim_name = 'sim_data_1';
cfg.source_name = 'mult_cort_src_sine';
cfg.exp_name = 'ex2_snr';
cfg.file_in = ['..' filesep 'output' filesep...
    'sim_data_1_mult_cort_src_sine_ex2_snr.mat'];
analysis_plot_data(cfg);

