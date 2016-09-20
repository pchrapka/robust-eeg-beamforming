%% source_setup.m
clear all;
close all;
clc;


%% Setup the source parameter file to test

cfg = [];
cfg.sim_data = 'sim_data_2';
cfg.sim_src_parameters = 'src_param_distr_cortical_source_1';
% Load the simulation parameters
eval(cfg.sim_data);
eval(cfg.sim_src_parameters);

% Modify the simulation config for testing purposes
% Add a suffix to the simulation name so it gets saved in a different
% folder
sim_cfg.sim_name = [sim_cfg.sim_name '_test'];
cur_snr = 0;
sim_cfg.snr_range = cur_snr; % Only use one snr
sim_cfg.n_runs = 1; % One iteration

cfg.sim_cfg = sim_cfg;

%% Simulate signal

% Options
simulate_data = false;
simulate_sources = true;

if simulate_data
    % Create the data
    simulation_data(cfg);
    
    % Get the data file name
    data_set = SimDataSetEEG(...
        sim_cfg.sim_name,...
        sim_cfg.source_name,...
        cur_snr,...
        'iter',1);
    data_file = db.save_setup('data_set',data_set);
    
    % Load the simulated data
    data_in = load(data_file);
end

if simulate_sources
    % Create source signals manually
    source_cfg.timepoints = sim_cfg.timepoints;
    source_cfg.fsample = sim_cfg.fsample;
    source_cfg.sources = sim_cfg.sources;
    source_signal = aet_sim_sources_trial(source_cfg);
end

%% Visualize source
if simulate_sources
    n_plots = length(source_cfg.sources);
    if n_plots > 6
        figure;
        for k=1:n_plots
            t_axis = 1:size(source_signal,2);
            hold on;
            plot(t_axis, source_signal(k,:));
            title([source_cfg.sources{k}.type...
                ' at ' num2str(source_cfg.sources{k}.source_index)]);
            xlim([1 300]);
        end
    else
        figure;
        t_axis = 1:size(source_signal,2);
        for k=1:n_plots
            subplot(n_plots,1,k);
            plot(t_axis, source_signal(k,:));
            title([source_cfg.sources{k}.type...
                ' at ' num2str(source_cfg.sources{k}.source_index)]);
            xlim([1 300]);
        end
    end
   
   sig_cov = cov(source_signal(1,:), source_signal(2,:));
   disp('cov = ');
   disp(sig_cov);
   
   [sig_xcorr,lags] = xcorr(source_signal(1,:), source_signal(2,:));
   % disp('xcorr = ');
   % disp(sig_xcorr);
   figure;
   plot(lags,sig_xcorr);
   
end