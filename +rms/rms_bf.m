function [rmse, rms_input] = rms_bf(cfg)
%RMS_BF Calculates the RMS error for a single set of beamformer outputs
%
%   cfg.bf_out  
%       beamformer output [components vertices samples]
%   cfg.sample_idx
%       sample index at which to calculate the RMS error
%       (must specify one of sample_idx or location_idx)
%   cfg.location_idx
%       location index at which to calculate the RMS error
%       (must specify one of sample_idx or location_idx)
%           
%   cfg.true_peak
%       index of the true peak
%   cfg.source_type     ('single', 'distr', 'mult')
%       type of source being analyzed
%
%   source_type = 'mult'
%   cfg.head    head struct (see hm_get_data)
%
%   source_type = 'distr'
%   cfg.input_signal
%       input signal for the source configuration 
%       [components vertices samples]

% TODO At what time do I do it? 
% - User-input?
% - Max response?

% Load the beamformer output
% data_bf = load(cfg.bf_out);
bf = cfg.bf_out;

% Double check that the beamformer output is correct
n_comp = size(bf,1);
if n_comp ~= 3
    error('rms:rms_bf',...
        ['Check the size of the beamformer output ' num2str(n_comp)]);
end

%% Select the data at the user sample index
if isfield(cfg,'sample_idx') && isfield(cfg,'location_idx')
    bf_select = squeeze(bf(:, cfg.location_idx, cfg.sample_idx)); 
    input_select = squeeze(cfg.input_signal(:, cfg.location_idx, cfg.sample_idx)); 
elseif isfield(cfg,'sample_idx')
    bf_select = squeeze(bf(:, :, cfg.sample_idx)); 
    input_select = squeeze(cfg.input_signal(:, :, cfg.sample_idx)); 
elseif isfield(cfg,'location_idx')
    bf_select = squeeze(bf(:, cfg.location_idx, :)); 
    input_select = squeeze(cfg.input_signal(:, cfg.location_idx, :)); 
else
    error('rms:rms_bf',...
        'must specify either sample_idx or location_idx');
end

%% Calculate the RMSE
cfg.bf_out = bf_select';
cfg.input = input_select';
switch cfg.source_type
    case 'single'
        [rmse, rms_input] = rms.rms_single_bf(cfg);
    case 'mult'
        [rmse, rms_input] = rms.rms_mult_bf(cfg);
    case 'distr'
        [rmse, rms_input] = rms.rms_distr_bf(cfg);
    otherwise
        error('rms:rms_bf',...
        ['Unknown source type ' cfg.source_type]);
end

end

