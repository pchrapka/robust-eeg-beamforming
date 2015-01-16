function [rmse, rms_input] = rms_distr_bf(cfg)
%RMS_DISTR_BF calculates the RMS error of the beamformer output on data
%from a distributed source scenario
%
%   cfg.bf_out
%       beamformer amplitude
%   cfg.input
%       input amplitude
%   cfg.true_peak
%       index of the true peak

% Calculate the RMS error
[rmse, rms_input, ~] = rms.rms_error(cfg.bf_out, cfg.input);

end