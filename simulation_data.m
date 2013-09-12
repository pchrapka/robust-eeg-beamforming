%% Script for creating the data

%% Clear everything
clc;
clear;
close all;

%% Initialize the Advanced EEG Toolbox
aet_init

%% Load the simulation parameters
sim_parameter_file

%% Load the head model
aet_output(sim_cfg, 1, 'Loading the head model\n');
head_model_data = ['..' filesep 'head-models'...
    filesep sim_cfg.head_model_file];
load(head_model_data);
sim_cfg.head = head;

% Figure out number of channels
gain_temp = aet_source_get_gain(1, sim_cfg.head);
sim_cfg.n_channels = size(gain_temp,1);

%% Control parallel execution explicity
sim_cfg.parallel = 'user';
aet_parallel_init(sim_cfg)

%% Generate/load data
data = aet_sim_create_eeg(sim_cfg);
% Save the data
sim_cfg.data_type = 'eeg_data';
aet_save(sim_cfg, data);

%% End parallel execution
sim_cfg.parallel = '';
aet_parallel_close(sim_cfg)