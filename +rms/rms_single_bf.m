function [rmse, rms_input] = rms_single_bf(cfg)
%RMS_SINGLE_BF calculates the RMS error of the beamformer output on data
%from a single source scenario
%
%   cfg.bf_power
%       beamformer power
%   cfg.true_peak
%       index of the true peak

% % Create the input power
% input_power = zeros(size(cfg.bf_power));
% input_power(cfg.true_peak) = 1;

% Calculate the RMSE error
[rmse, rms_input] = rms.rms_error(cfg.bf_power, input_power);

end