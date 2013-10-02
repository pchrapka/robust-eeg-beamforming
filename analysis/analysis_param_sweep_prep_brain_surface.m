function [ cfg ] = analysis_param_sweep_prep_brain_surface(cfg)
%ANALYSIS_PARAM_SWEEP_PREP_BRAIN_SURFACE
%   ANALYSIS_PARAM_SWEEP_PREP_BRAIN_SURFACE(CFG) calculates the output of a
%   beamformer using the weight matrix calculated in the parameter sweep
%   functions. It also replaces the appropriate field in the struct
%   exported from the WMN analysis in Brainstorm to be able to plot the
%   data on a brain surface.
%
%   Input
%   cfg
%       file_in     output data from simulation_variations
%       iteration   selects iteration from data
%       snr         selects snr value from data
%       epsilon     (required if beamformer type is rmv
%                   selects epsilon value from data
%       bst_source  exported data from Brainstorm from results of weighted
%                   minimum norm analysis (WMN)
%
%   Output
%   cfg     same struct as before, with the following fields updated
%       bst_source  updated with the beamformer output
%       eeg_data    EEG data used for the analysis
%
%   See also SIMULATION_VARIATIONS

% FIXME Maybe there's a way to get this from cfg.bst_source
n_components = 3;

% Load the file
% The format will be a parameter sweep
load(cfg.file_in)   % loads variable out

% Select the data for plotting
% Iteration
out_temp = out([out.iteration] == cfg.iteration);
% SNR
out_temp = out_temp([out.snr] == cfg.snr);
% Epsilon, if it's there
if isfield(out_temp(1), 'epsilon')
    out_temp = out_temp(...
        cellfun(@(x)isequal(x, cfg.epsilon'),...
        {out_temp.epsilon}));
end

% Make sure the number of vertices matches in the head model the length of
% the data array
n_vertices = size(cfg.bst_source.ImageGridAmp,1)/n_components;
n_time = size(cfg.bst_source.ImageGridAmp,2);
if n_vertices ~= length(out_temp)
    warning('reb:analysis_plot_brain_surface',...
        'Dealbreaker');
end

% Load the EEG data
% NOTE At this point we should have filtered down to a single data set
load(out_temp(1).data_file);    % loads variable data
% NOTE I am only doing the signal + noise portion
    warning('reb:analysis_plot_brain_surface',...
        'Only using signal + noise in output, no interference source');
cfg.eeg_data = data.avg_signal + data.avg_noise;
clear data;

% Allocate memory
beam_data = zeros(n_components, n_vertices, n_time);
% Loop over all vertices
for i=1:n_vertices
    out_cur_loc = out_temp([out_temp.loc] == i);
    
    % Set up the config to get the beamformer output
    beam_cfg.type = out_cur_loc.beamformer_type;
    beam_cfg.W = out_cur_loc.W;
    if isequal(out_cur_loc.beamformer_type, 'beamspace')
        beam_cfg.T = out_cur_loc.T;
    end
    
    % Calculate the output
    beam_output = aet_analysis_beamform_output(...
        beam_cfg, cfg.eeg_data);
    
    % Format output for Brainstorm
    for j=1:n_components
        beam_data(j,i,:) = beam_output(j,:);
    end
end

% Reshape the data
cfg.bst_source.ImageGridAmp = reshape(beam_data,...
    [n_components*n_vertices n_time]);

end