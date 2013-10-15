%% run_simulation_4.m -- All example simulations
% Runs all the simulations using sim_beam_5

clear all;
close all;
clc;

%% Update AET, just in case
update_aet()

%% Initialize the Advanced EEG Toolbox
aet_init
k = 1;

%% Set up scripts to run

%% Ex1
% Exact leadfield case

% SNR sweepts at differnt epsilon values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

scripts(k).func = @simulation_ex1_snr;
cfg = struct(...
    'sim_data',             'sim_data_1',...
    'sim_src_parameters',   'src_param_mult_cortical_source',...
    'sim_beam',             'sim_beam_5',...
    'sim_file_out',         'mult_cort_src_ex1_snr_eps_many');
scripts(k).vars = {cfg};
k = k+1;

scripts(k).func = @simulation_ex1_snr;
cfg = struct(...
    'sim_data',             'sim_data_1',...
    'sim_src_parameters',   'src_param_mult_cortical_source_2',...
    'sim_beam',             'sim_beam_5',...
    'sim_file_out',         'mult_cort_src_2_ex1_snr_eps_many');
scripts(k).vars = {cfg};
k = k+1;

scripts(k).func = @simulation_ex1_snr;
cfg = struct(...
    'sim_data',             'sim_data_1',...
    'sim_src_parameters',   'src_param_mult_cortical_source_3',...
    'sim_beam',             'sim_beam_5',...
    'sim_file_out',         'mult_cort_src_3_ex1_snr_eps_many');
scripts(k).vars = {cfg};
k = k+1;

%% Ex2
% Mismatched leadfield case

% SNR sweepts at differnt epsilon values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

scripts(k).func = @simulation_ex2_snr;
cfg = struct(...
    'sim_data',             'sim_data_1',...
    'sim_src_parameters',   'src_param_mult_cortical_source',...
    'sim_beam',             'sim_beam_5',...
    'sim_file_out',         'mult_cort_src_ex2_snr_eps_many');
scripts(k).vars = {cfg};
k = k+1;

scripts(k).func = @simulation_ex2_snr;
cfg = struct(...
    'sim_data',             'sim_data_1',...
    'sim_src_parameters',   'src_param_mult_cortical_source_2',...
    'sim_beam',             'sim_beam_5',...
    'sim_file_out',         'mult_cort_src_2_ex2_snr_eps_many');
scripts(k).vars = {cfg};
k = k+1;

scripts(k).func = @simulation_ex2_snr;
cfg = struct(...
    'sim_data',             'sim_data_1',...
    'sim_src_parameters',   'src_param_mult_cortical_source_3',...
    'sim_beam',             'sim_beam_5',...
    'sim_file_out',         'mult_cort_src_3_ex2_snr_eps_many');
scripts(k).vars = {cfg};
k = k+1;

%% Run the scripts
aet_run_scripts( scripts );