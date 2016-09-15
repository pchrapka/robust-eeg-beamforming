function [output] = snr(cfg)
%SNR calculates the SNR of the signal
%   cfg.S
%       signal matrix [channels samples]
%   cfg.N
%       noise matrix [channels samples]
%   cfg.W
%       spatial filter [channels components]
%
%   Output
%   ------
%   output.snr
%       signal to noise ratio
%   output.snrdb
%       signal to noise ratio in dB

Rs = cov(cfg.S);
Rn = cov(cfg.N);

% Calculate the snr
output.snr = trace(cfg.W' * Rs * cfg.W)/...
    trace(cfg.W' * Rn * cfg.W);

% Convert snr to dB
% Only 10 because I think the SNR above is power
output.snrdb = 10*log10(output.snr);


end