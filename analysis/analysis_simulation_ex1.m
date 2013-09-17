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

%% Set parameters
cfg.sim_name = 'sim_param_file';
cfg.source_name = 'single_cort_src';
    
%% Create plots

analysis_simulation_ex1_snr(cfg);
% analysis_simulation_ex1_epsilon
