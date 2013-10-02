function [ cfg ] = analysis_param_sweep_select_data(cfg)
%ANALYSIS_PARAM_SWEEP_SELECT_DATA
%   ANALYSIS_PARAM_SWEEP_SELECT_DATA(CFG) selects data from parameter sweep
%   based on CFG
%
%   Input
%   cfg
%       file_in     output data from simulation_variations
%       iteration   selects iteration from data
%       snr         selects snr value from data
%       epsilon     (required if beamformer type is rmv
%                   selects epsilon value from data
%
%   Output
%   cfg     same struct as before, with the following fields updated
%       eeg_data    EEG data used for the analysis
%
%   See also SIMULATION_VARIATIONS

% FIXME Maybe there's a way to get this from cfg.bst_source
n_components = 3;

% Load the file
% The format will be a parameter sweep
load(cfg.file_in)   % loads variable out
out_temp = out;
clear out;

% Select the data for plotting
% Iteration
out_temp = out_temp([out_temp.iteration] == cfg.iteration);
% SNR
out_temp = out_temp([out_temp.snr] == cfg.snr);
% Epsilon, if it's there
if isfield(out_temp(1), 'epsilon')
    out_temp = out_temp(...
        cellfun(@(x)isequal(x, cfg.epsilon),...
        {out_temp.epsilon}));
end

% Load the EEG data
% NOTE At this point we should have filtered down to a single data set
data_file = ['..' filesep out_temp(1).data_file];
% Replace slashes just in case
data_file = strrep(data_file, '/', filesep);
load(data_file);    % loads variable data
cfg.eeg_data = data.avg_trials;
clear data;

cfg.out = out_temp;

end