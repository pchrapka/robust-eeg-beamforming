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
% scripts(k).func = @simulation_ex1_snr;
% scripts(k).vars = {...
%     'sim_param_file',...
%     'src_param_mult_cortical_source'};
% k = k+1;

% scripts(k).func = @simulation_data;
% scripts(k).vars = {...
%     'sim_param_file',...
%     'src_param_mult_cortical_source'};
% k = k+1;

scripts(k).func = @simulation_ex1_snr;
scripts(k).vars = {...
    'sim_param_file',...
    'src_param_mult_cortical_source'};
k = k+1;

% scripts(k).func = @simulation_ex1_epsilon;
% scripts(k).vars = {...
%     'sim_param_file',...
%     'src_param_mult_cortical_source'};
% k = k+1;



%% Run the scripts
aet_run_scripts( scripts );
