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

Rs = cov(cfg.S');
Rn = cov(cfg.N');

nchannels = size(Rs,1);
num = trace(cfg.W' * Rs * cfg.W);
den = trace(cfg.W' * Rn * cfg.W)/nchannels;

% Calculate the snr
output.snr = num/den;

% Convert snr to dB
% Only 10 because I think the SNR above is power
output.snrdb = 10*log10(output.snr);


end