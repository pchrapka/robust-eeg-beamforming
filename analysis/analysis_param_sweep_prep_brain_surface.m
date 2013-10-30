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
% %       file_in     output data from simulation_variations
% %       iteration   selects iteration from data
% %       snr         selects snr value from data
% %       epsilon     (required if beamformer type is rmv
% %                   selects epsilon value from data
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

% Make sure the number of vertices matches in the head model the length of
% the data array
n_vertices = size(cfg.bst_source.ImageGridAmp,1)/n_components;
n_time = size(cfg.bst_source.ImageGridAmp,2);
if n_vertices ~= length(cfg.out)
    warning('reb:analysis_plot_brain_surface',...
        'Dealbreaker');
end

fprintf('Computing beamformer output\n');

% Allocate memory
beam_data = zeros(n_components, n_vertices, n_time);
% Loop over all vertices
for i=1:n_vertices
    out_cur_loc = cfg.out([cfg.out.loc] == i);
    
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
cfg.beam_data = beam_data;
cfg.bst_source.ImageGridAmp = reshape(beam_data,...
    [n_components*n_vertices n_time]);

end