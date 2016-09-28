function [output] = isnr(cfg)
%ISNR calculates the ISNR of the signal
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
%   output.isnr
%       interference to signal + noise ratio
%   output.isnrdb
%       interference to signal + noise ratio in dB

Rs = cov(cfg.S');
Ri = cov(cfg.I');
Rn = cov(cfg.N');

nchannels = size(Rs,1);
num = trace(cfg.W' * Ri * cfg.W);
den = trace(cfg.W' * Rs * cfg.W) + trace(cfg.W' * Rn * cfg.W)/nchannels;

% Calculate the isnr
output.isnr = num/den;

% Convert snr to dB
% Only 10 because I think the SNR above is power
output.isnrdb = 10*log10(output.isnr);


end