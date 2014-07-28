function [rmse, rms_input] = rms_single_bf(cfg)
%RMS_SINGLE_BF calculates the RMS error of the beamformer output on data
%from a single source scenario
%
%   cfg.bf_out
%       beamformer amplitude
%   cfg.input
%       input amplitude
%   cfg.true_peak
%       index of the true peak

% Calculate the RMSE error
[rmse, rms_input, ~] = rms.rms_error(cfg.bf_out, cfg.input);

end