%% run_simulation.m -- All example simulations
% Runs all the simulations

clear all;
close all;
clc;

%% Update AET, just in case
update_aet()

%% Initialize the Advanced EEG Toolbox
aet_init
k = 1;

%% Set up scripts to run


% scripts(k).func = @simulation_data;
% scripts(k).vars = {...
%     'sim_data_1',...
%     'src_param_mult_cortical_source'};
% k = k+1;

%% Ex1
% scripts(k).func = @simulation_ex1_snr;
% scripts(k).vars = {...
%     'sim_data_1',...
%     'src_param_mult_cortical_source'};
% k = k+1;

% scripts(k).func = @simulation_ex1_epsilon;
% scripts(k).vars = {...
%     'sim_data_1',...
%     'src_param_mult_cortical_source'};
% k = k+1;

%% Ex2
% scripts(k).func = @simulation_ex2_snr;
% scripts(k).vars = {...
%     'sim_data_1',...
%     'src_param_mult_cortical_source'};
% k = k+1;

% scripts(k).func = @simulation_ex2_epsilon;
% scripts(k).vars = {...
%     'sim_data_1',...
%     'src_param_mult_cortical_source'};
% k = k+1;

%% Sinusoid signal

% scripts(k).func = @simulation_data;
% scripts(k).vars = {...
%     'sim_data_1',...
%     'src_param_mult_cortical_source_sine'};
% k = k+1;

% scripts(k).func = @simulation_ex2_snr;
% scripts(k).vars = {...
%     'sim_data_1',...
%     'src_param_mult_cortical_source_sine'};
% k = k+1;

%% Parameter sweep

% scripts(k).func = @simulation_data;
% scripts(k).vars = {...
%     'sim_data_1',...
%     'src_param_mult_cortical_source'};
% k = k+1;

scripts(k).func = @simulation_variations_all;
scripts(k).vars = {...
    'sim_data_1',...
    'sim_vars_1',...
    'src_param_mult_cortical_source'};
k = k+1;




%% Run the scripts
aet_run_scripts( scripts );
