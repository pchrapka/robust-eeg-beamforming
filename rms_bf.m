function [rms, rms_peak] = rms_bf(cfg)
%RMS_BF calculates the RMS error of the beamformer
%
%   cfg.head    head struct (see hm_get_data)
%   cfg.bf_out  beamformer output [components vertices samples]
%   cfg.sample_idx
%               sample index at which to calculate the dispersion
%   cfg.true_peak
%               index of the true peak

% TODO At what time do I do it? 
% - User-input?
% - Max response?

% Load the beamformer output
% data_bf = load(cfg.bf_out);
bf = cfg.bf_out;

% Double check that the beamformer output is correct
n_comp = size(bf,1);
if n_comp ~= 3
    error('rmvb:rms_bf',...
        ['Check the size of the beamformer output ' num2str(n_comp)]);
end

%% Calculate the power at each index and the user's sample index
% Select the data at the user sample index
bf_select = squeeze(bf(:,:,cfg.sample_idx)); 

% Square each element
bf_select = bf_select.^2;
% Sum the components at each index and each time point
bf_sum = sum(bf_select,1);
% Take the square root of each element
bf_power = sqrt(bf_sum);

if ~isvector(bf_power)
    warning('rmvb:rms_bf',...
        'A matrix version has not been implemented');
end

%% Select points of interest

poi = true(size(bf_power));
% Select all points except the peak
poi(cfg.true_peak) = false;

%% Calculate the RMS error
rms = sqrt(sum(bf_power(poi).^2)/length(bf_power));
rms_peak = bf_power(cfg.true_peak);
end