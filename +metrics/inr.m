function [output] = inr(cfg)
%INR calculates the INR of the signal
%   cfg.I
%       interference matrix [channels samples]
%   cfg.N
%       noise matrix [channels samples]
%   cfg.W
%       spatial filter [channels components]
%
%   Output
%   ------
%   output.inr
%       interference to noise ratio
%   output.inrdb
%       interference to noise ratio in dB

Ri = cov(cfg.I');
Rn = cov(cfg.N');

nchannels = size(Rs,1);
num = trace(cfg.W' * Ri * cfg.W);
den = trace(cfg.W' * Rn * cfg.W)/nchannels;

% Calculate the inr
output.inr = num/den;

% Convert snr to dB
% Only 10 because I think the SNR above is power
output.inrdb = 10*log10(output.inr);


end