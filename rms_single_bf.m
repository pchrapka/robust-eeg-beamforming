function [rms, rms_peak] = rms_single_bf(cfg)
%RMS_SINGLE_BF calculates the RMS error of the beamformer output on data
%from a single source scenario
%
%   cfg.bf_power
%       beamformer power
%   cfg.true_peak
%       index of the true peak

% Calculate the RMS error
poi = true(size(cfg.bf_power));
[rms, rms_peak] = rms_error(cfg.bf_power, cfg.true_peak, poi);

end