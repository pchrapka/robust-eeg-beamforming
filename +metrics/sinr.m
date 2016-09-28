function [output] = sinr(cfg)
%SINR calculates the SINR of the signal
%   cfg.S
%       signal matrix [channels samples]
%   cfg.I
%       interference matrix [channels samples]
%   cfg.N
%       noise matrix [channels samples]
%   cfg.W
%       spatial filter [channels components]
%
%   Output
%   ------
%   output.sinr
%       signal to interference + noise ratio
%   output.sinrdb
%       signal to interference + noise ratio in dB


% Calculate the sinr
Rs = cov(cfg.S');
Ri = cov(cfg.I');
Rn = cov(cfg.N');

nchannels = size(Rs,1);
num = trace(cfg.W' * Rs * cfg.W);
den = trace(cfg.W' * Ri * cfg.W) + trace(cfg.W' * Rn * cfg.W)/nchannels;

% Calculate the sinr
output.sinr = num/den;

% Convert snr to dB
% Only 10 because I think the SNR above is power
output.sinrdb = 10*log10(output.sinr);


end