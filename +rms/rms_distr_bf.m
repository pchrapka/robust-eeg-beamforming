function [rmse, rms_peak] = rms_distr_bf(cfg)
%RMS_DISTR_BF calculates the RMS error of the beamformer output on data
%from a distributed source scenario
%
%   cfg.bf_power
%       beamformer power
%   cfg.input_power
%       input power
%   cfg.true_peak
%       index of the true peak

% Calculate the RMS error
[rmse, rms_peak] = rms.rms_error(cfg.bf_power, cfg.input_power);

end